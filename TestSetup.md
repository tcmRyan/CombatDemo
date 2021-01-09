# Getting Started: Roblox Test Setup Guide

The goal of this guide is to take a user who is new to writing tests in Roblox and get their environment setup in a way that lets them effectively test. This guide assumes that you have some familiarity with Roblox Studio, the terminal, and Integrated Development Environments(IDE). It also assumes that you have installed [Git] and are familiar with it's usage.

The recommended IDE is [Visual Studio Code][vscode] since that seems to have the most robust plugin support at this time.

As with most tools, there are multiple ways to setup your environment. This guide takes an opinionated approach to ensure clarity. If you are comfortable with many of these tools, feel free to install them how you see fit and use this guide more like a checklist.

## Installing the toolchain

### Step 1: Download Visual Studio and the C++ Build BuildTools

We are going to need the build tools for some installations down the road so lets download these dependencies.

1. [Download Visual Studio][vs-downloads] and install
2. [Download C++ BuildTools][vs-c++] and install

### Step 2: Download Rust

Many of thte tools that we are going to need are built in Rust and can be installed through Rust's package manager: Cargo

1. [Download Rust][rust-downloads]
2. Add Cargo to your Path. The path to Cargo should appear during Rust's install. On Windows the will look something like `%USERPROFILE%\.cargo\bin`.
3. Refresh your terminal window

**Note:** IF you don't know how to add variables to your PATH you can looks at the following: [Windows][windows-path], [MAC][mac-path]

### Step 3: Use Cargo to install Foreman

[Foreman] is a toolchain manager for many Roblox tools. While most of these can be installed other ways, foreman is the recommended way to go about this.

1. In the terminal run `cargo install foreman`
2. Add Foreman to your PATH. On windows this will look something like: `C:\Users\<username>\.foreman\bin`

### Step 4: Add Roblox Tools Via Foreman

[Rojo][rojo-docs] is what is going to enable us to use professional development tools. This will serve as you like between your IDE and Roblox.

[Run-in-roblox] is a tool to run a place, a model, or an individual script inside Roblox Studio. We need this to avoid having to mock out all of the Roblox functionality that our project depends on.

1. Go to your Foreman directory ex: `C:\Users\<username>\.foreman` and add rojo to your foreman.toml file. Your file shoulf look something like:

   ```sh
   # This is Foreman's configuration file. You can edit it to tell Foreman about
   # new tools that you'd like to install, or to change versions of tools you
   # already have.

   # When adding new tools, make sure to run `foreman install` so that their
   # binaries are installed.

   [tools]
   # Put any tools you want to install here. To install Rojo 0.5.x, you'd use:
   rojo = { source = "rojo-rbx/rojo", version = "0.5" }
   run-in-roblox = { source = "rojo-rbx/run-in-roblox", version = "0.3.0" }
   ```

2. In the terminal run `foreman install` to install rojo and run-in-roblox.
3. Test out your installs. Run `rojo --help` and `run-in-roblox` to confirm that they have been installed successfully.

### Step 5: Install Rojo Roblox Plugin

Rojo also requires that you have the plugin install inside Roblox Studio.

1. Click the link to install the Rojo plugin into your Roblox Studio: [Install the Rojo Plugin][rojo-studio-plugin]

### Step 6: Install rbxlx-to-rojo

[rbxlx-to-rojo] is necessary if you want to convert your existing project to rojo. In this guide we are going to create a partially managed Rojo environment. If you want to ready more about the difference between partially managed and fully managed you can read [the documentation][rojo-part-v-full].

1. [Download the latest release][rbxlx-to-rojo-releases]

### === Tooling Dependency Setup complete ===

Congatulations! Our tooling dependencies are all installed. We can now move onto getting our project setup.

## Project Setup

This section will cover getting your Roblox project migrated over to Rojo and how to get TestEZ working in your repository.

### Step 1: Migrating your project to Rojo and

1. Follow the directions in the [README][rbxlx-to-rojo] to migrate your project to Rojo.

### Step 2: Pull TestEZ into your project

[TestEZ] is the recommended testing library to run your Roblox automated tests. It follows the popular Behavior Driven Development patterns, allowing the developer to describe the behavior of project in a human readable way.

1. Open up the project you created in Visual Studio Code
2. Create a new folder called "modules" and
3. Open the terminal in VSCode and type `cd modules`
4. In the terminal run `git submodule add https://github.com/Roblox/testez.git`
5. You should now have TestEZ available in your modules folder.
6. `cd ..` to go back to the root of your project

### Step 3: Setup Your default.project.json

When you generated your Rojo project, a `default.project.json` file was generated for you. This file provides Rojo with a map from your project to Roblox Studio. By default it should look something like this:

```json
{
  "name": "project",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "$ignoreUnknownInstances": true,
      "$path": "src/ReplicatedStorage"
    }
  }
}
```

We need to make TestEZ available to Roblox so that we can run the tests in the Roblox environment. To do that we are going to add some lines that makes TestEZ available in ReplicatedStorage.

```json
{
  "name": "project",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "$ignoreUnknownInstances": true,
      "$path": "src/ReplicatedStorage",
      "TestEZ": {
        "$path": "modules/testez/src"
      },
      "Tests": {
        "$path": "Tests.lua"
      }
    }
  }
}
```

### Step 4: Create a Helper script to collect the tests

Next we need to write a small helper script to help us pass tests to TestEZ and collect the output.

Create a new script called `Tests.lua` in the root of the project.

```lua
-- We have access to the ReplicatedStorage because we are using run-in-roblox to run in the Roblox environment.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- TestEZ is available to us now because of the lines we
-- added in the previous step to default.project.json
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ"))

--- The testing function.
-- Accepts a list of roots, runs tests on them, then reports on test status.
--
-- @param roots a table of roots to find tests
-- @return whether the tests completed
-- @return true if the tests were successful, false if the tests were
-- unsuccessful, an error message if the tests were not completed
local function Tests(roots)
    print("Running Tests")
    -- Listen to the results from TestEZ so we can view output
    local completed, result = xpcall(function()
        -- Run the tests with TestEZ
        local results = TestEZ.TestBootstrap:run(roots)
        return results.failureCount == 0
    end, debug.traceback)
    print()
    return completed, result
end

-- Return this function so we can run it with run-in-roblox.
-- Also will work with Lemur
return Tests
```

### Step 5: Add the helper script to default.project.json

Let's open `default.project.json` back up and add our little helper to it.

```json
{
  "name": "project",
  "tree": {
    "$className": "DataModel",
    "ReplicatedStorage": {
      "$className": "ReplicatedStorage",
      "$ignoreUnknownInstances": true,
      "$path": "src/ReplicatedStorage",
      "TestEZ": {
        "$path": "modules/testez/src"
      },
      "Tests": {
        "$path": "Tests.lua"
      }
    }
  }
}
```

### Step 6: Create our script for run-in-roblox

The last thing that we need to do before we can write and run some tests is to create a script to pass to run-in-roblox. This script is where we tell TestEz to look for tests. In our example we are just going to have all our tests in ReplicatedStorage.

Create a new script called `Run.server.lua`

```lua
--- The Roblox test runner script.
-- This script can run within Roblox to perform automated tests.
--
-- @module TestRunner
-- @version 0.1.1, 2020-11-03
-- @since 0.1
--
-- @throws when the tests fail

-- We have access to the ReplicatedStorage because we
-- are using run-in-roblox to run in the Roblox environment.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Our Test Helper is available to us now because of the lines we
-- added in the previous step to default.project.json
local Tests = require(ReplicatedStorage:WaitForChild("Tests"))

-- The locations containing tests. Other examples:
-- local Roots = {ReplicatedStorage.myProject}
-- local Roots = {ReplicatedStorage, ServerScriptService}
local Roots = {ReplicatedStorage}

-- Execute our test function
local completed, result = Tests(Roots)

if completed then
    if not result then
        error("Tests have failed.", 0)
    end
else
    error(result, 0)
end
```

### === Project Setup Complete ===

We know have the environment configured to be able to collect and run tests! The next section covers writing a simple tests and running it in Roblox.

## Writing and Running Tests

With all the setup work done, we can checkout out the [TestEZ documentation][testez-docs] to learn more about how to write tests using this framework. For now we are just going to use the [example][testez-example] in the documentation to test that our environment is working.

### Step 1: Write a simple example

Create a new file in `src/ReplicatedStorage` called `Greeter.lua`

```lua
local Greeter = {}

function Greeter:greet(person)
    return "Hello, " .. person
end

return Greeter
```

### Step 2: Write a test for our example

Create a new file in `src/ReplicatedStorage` called `Greeter.spec.lua`

```lua
return function()
    local Greeter = require(script.Parent.Greeter)

    describe("greet", function()
        it("should include the customary English greeting", function()
            local greeting = Greeter:greet("X")
            expect(greeting:match("Hello")).to.be.ok()
        end)

        it("should include the person being greeted", function()
            local greeting = Greeter:greet("Joe")
            expect(greeting:match("Joe")).to.be.ok()
        end)
    end)
end
```

### Step 3: Build an rbxlx file with Rojo

We will need to create a `.rbxlx` file to pass to `run-in-rojo` to run our project. Run-in-rojo is going to essentially take that file and create a clone of our project in Roblox. We can then run our tests against that clone.

1. In the terminal run `rojo build -o test.rbxlx`

You should now see a `test.rbxlx` file in the root of your project that was built by rojo using your `default.project.json`

### Step 4: Run the Tests

We are now ready to run the tests!

1. In the terminal run `run-in-roblox --place test.rbxlx --script Run.server.lua`

You should see an instance of Roblox Studio get created, run the tests, and then get shut down. The output of the tests should be recorded in your terminal.

### Happy Testing

[//]: # "These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax"
[vs-downloads]: https://visualstudio.microsoft.com/downloads/
[vs-c++]: https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16
[rust-downloads]: https://www.rust-lang.org/learn/get-started
[mac-path]: https://www.cyberciti.biz/faq/appleosx-bash-unix-change-set-path-environment-variable/
[windows-path]: https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/
[foreman]: https://github.com/Roblox/foreman
[rojo-docs]: https://rojo.space/docs/
[rojo-repo]: https://github.com/rojo-rbx/rojo.space/
[run-in-roblox]: https://github.com/rojo-rbx/run-in-roblox
[rbxlx-to-rojo-releases]: https://github.com/rojo-rbx/rbxlx-to-rojo/releases
[rbxlx-to-rojo]: https://github.com/rojo-rbx/rbxlx-to-rojo
[rbxlx-to-rojo-releases]: https://github.com/rojo-rbx/rbxlx-to-rojo/releases
[vscode]: https://code.visualstudio.com/
[rojo-studio-plugin]: https://www.roblox.com/library/1997686364/Rojo-0-5-4
[rojo-part-v-full]: https://rojo.space/docs/0.5.x/reference/full-vs-partial/
[testez]: https://github.com/Roblox/testez
[git]: https://git-scm.com/
[testez-docs]: https://roblox.github.io/testez/
[testez-example]: https://roblox.github.io/testez/getting-started/writing-tests/
