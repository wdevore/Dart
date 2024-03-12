# Info
Create in March 2024

by William Cleveland

# Java
To run some of the older SoftRenderer4 java code you need to install some form of java.

First install some version of java:

```sh
sudo apt install openjdk-11-jre-headless
```

Then install vecmath library:
```sh
sudo apt-get install libvecmath-java
```

To locate where the vecmath jar is use:
```sh
dpkg -L libvecmath-java
```
Which generates a list of locations. We want the direct location:
```
...
/usr/share/java/vecmath-1.5.2.jar
...
```

Now run your program that contains an import for vecmath. You can make a Make file to help.

```sh
java -cp /usr/share/java/vecmath-1.5.2.jar test.java
```

## VSCode
[VSCode configurations](https://code.visualstudio.com/docs/java/java-project)

You can also set the classpath and references in VSCode's *settings.json* file by adding these two entries:

```json
"java.configuration.runtimes": [
    {
        "name": "JavaSE-11",
        "path": "/usr/lib/jvm/java-11-openjdk-amd64"
    },
],
"java.project.referencedLibraries": [
    "lib/**/*.jar",
    "/usr/share/java/vecmath-1.5.2.jar"
]
```