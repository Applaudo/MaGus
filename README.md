# MaGus

:sparkles: iOS project generation tool


# Summary
MaGus is a command line tool, written in Swift, that generates base files for an iOS project. It creates all base files needed to generate an Xcode project and build tools that will make your development process more efficient.

### Files Generated
-  project.json: This is a json file  ready to be used along with [XcodeGen](https://github.com/yonaskolb/XcodeGen)  to generate an XcodeProject.
- Fastfile: a Ruby file that is used for Fastlane in order to build your app easily from a CI or Command Line..
- MatchFile: Fastlane's companion tool that helps manage certificates easily and securely..
- GemFile: a Ruby file that defines the list of dependencies that you will need in order to build the project using Fastlane.
- AppDelegate, TestFiles and InfoPlist: These files are generated in order to provide the initial files required for a project.

More info about generated files [Here](Documentation/TEMPLATES.md)

### Installation
We currently support the use of [Mint](https://github.com/yonaskolb/mint) as the distribution system.

```
$ mint install applaudo/MaGus
```

### Usage
MaGus offers the following options from CLI:

```
USAGE: project-command --name <name> [--platform <platform>] --bundle-id <bundle-id> --deployment-target <deployment-target> [--output-path <output-path>] --team-id <team-id> --username <username> [--match-repo <match-repo>]

OPTIONS:
  --name <name>           Specify name of the project
  --platform <platform>   Specify platform of the project (default: iOS)
  --bundle-id <bundle-id> Specify Bundle ID for the project
  --deployment-target <deployment-target>
                          Specify desired deployment target for the project
  --output-path <output-path>
                          Specify path where you want to store generated
                          project (default: output)
  --team-id <team-id>     Team Id you will use to sign in your app
  --username <username>   username you will use to sign in certificates and get
                          from developer center
  --match-repo <match-repo>
                          Repo where your certificates are stored
  -h, --help              Show help information.
```

If you want to generate a project, run the following command:

```
MaGus --name SuperApp --bundle-id com.test.app --deployment-target 13.0 --team-id test --username test@test.com
```
This will generate all files and a folder named output in the current directory where the command was issued.  `output`.

Then if you want to generate an xcode project use [XcodeGen](https://github.com/yonaskolb/XcodeGen) and run:

```
xcodegen --spec project.json
```

### Extending Usage.

Add to your Package.swift

```swift
.package(url: "https://github.com/Applaudo/MaGus.git", .branch("master"))
```
Then in your Target reference MaGus Like:

```swift
.target(name: "MyAwesomeTool", dependencies: ["MaGusKit"]),
```

MaGus offers you a basic project generation, ready to be used; but sometimes you might want to extend its functionality and add custom templates, or use it inside another tool. Fortunately, MaGus offers you a set of API that will help you to extend it..

First import MaGus

```swift

import MaGusKit
```

Define a template representation using `TemplateInformation` protocol.

```swift

struct MyAwesomeTemplateInformation: TemplateInfomation {
    
    var context: TemplateContext {
        [
        "MyVariable": "Example" 
        ]
    }
       
    var templateName: String { 
         "awesomeTemplate"
    }
      
    var outputFilePath: Path { 
         "MyAwesomePath"
    }
    
    var fileName: String { 
        "AwesomeConfiguration"
    }   
}
```
Define your template in a multiline string. We don't use files due to lack of resources in Swift Package Manager (Hopefully we could change this when Swift 5.3 lands) 

```swift
let myAwesomeTemplate =
"""
Awesome_configuration("{{ configuration }}")
"""
```
Under the hood, MaGus uses [Stencil](https://github.com/stencilproject/Stencil) to define and create templates

Then, register your template

```swift
Templates.set(key: "MyAwesomeTemplate", template: myAwesomeTemplate)
```

Now, generate an instance of Project Information and Generator:

```swift

let information = ProjectInformation(name: name,
                                     platform: platform,
                                     bundleId: bundleId,
                                     deploymentTarget: deploymentTarget,
                                     username: username,
                                     teamId: teamId,
                                     matchRepo: matchRepo)

let projectGenerator = try ProjectGenerator(outputPath: outputPath,
                                            projectInformation: information)
                                            
```
With `ProjectGenerator` instance you are able to do the following in order to generate project files:

```swift
    let awesomeTemplateInformation = MyAwesomeTemplateInformation()
    
    /// Generate all of the base templates with your custom ones
    try projectGenerator.generate(for: .allWith(customs: [awesomeTemplateInformation]))
    
    /// Just Generate your custom templates
    try projectGenerator.generate(for: .custom(templates: []))
```

# Contributions
Pull requests and issues are always welcome. Please open any issues and PRs for bugs, features, or documentation.

# Credits

Made with :heart: by [Applaudo Studios](https://applaudostudios.com)

# Maintainers
 Manuel Sanchez
        - [Github](https://github.com/manasv)
        - [Twitter](https://twitter.com/_manasv)
 
 Gustavo Campos
        - [Github](https://github.com/guseducampos)
        - [Twitter](https://twitter.com/Gustereo)


## License
MaGus is licensed under the MIT license. See [LICENSE](LICENSE) for more info.
