# karate-expandtesting_api

API testing using [expandtesting docs](https://practice.expandtesting.com/notes/api/api-docs/). This project contains basic examples on how to use Karate, Java and Gherkin to test API tests. Good practices such as hooks, custom commands and tags, among others, are used. All the necessary support documentation to develop this project is placed here.

# Pre-requirements:

| Requirement                                    | Version        | Note                                                            |
| :--------------------------------------------- |:---------------| :-------------------------------------------------------------- |
| IntelliJ IDEA Community Edition                | 2024.3.3       | -                                                               |
| JDK                                            | 11.0.20        | -                                                               |
| Maven                                          | 3.9.9          | -                                                               |
| Karate JUnit 5 maven dependency                | 1.3.1          | -                                                               |
| Java Faker maven dependency                    | 1.0.2          | -                                                               |
| Karate JUnit 5 maven dependency                | 1.3.1          | -                                                               |
| Apache Maven Compiler Plugin maven dependency  | 3.13.0         | -                                                               |
| KMaven Surefire Plugin maven dependency        | 3.5.3          | -                                                               |

# Installation:

- See [IntelliJ IDEA Community Edition download page](https://www.jetbrains.com/idea/download/?section=windows), download and install IntelliJ IDEA Community Edition. Keep all the prefereced options as they are until you reach Instalation Options page. Then, check the checkboxes below: 
  - :white_check_mark: **IntelliJ IDEA Community Edition** on Create Desktop Shortcut frame; 
  - :white_check_mark: **Add "Open Folder as Project"** in Update Context Menu frame; 
  - :white_check_mark: **Add "bin" Folder to the PATH** in Update PATH Variable (restart needed) frame; 
  - :white_check_mark: **.java** in Create Associations frame; 
  - :white_check_mark: **.gradle** in Create Associations frame; 
  - :white_check_mark: **.groovy** in Create Associations frame; 
  - :white_check_mark: **.kt** in Create Associations frame; 
  - :white_check_mark: **.kts** in Create Associations frame; 
  - :white_check_mark: **.pom** in Create Associations frame;
  - Hit :point_right: **Next**, :point_right: **Install**, :radio_button: **I want to manually reboot later** and :point_right: **Finish**. Save your stuff and reboot the computer.
- See [Java SE 11 Archive Downloads](https://www.oracle.com/br/java/technologies/javase/jdk11-archive-downloads.html), download the proper version for your OS and install it by keeping the preferenced options. 
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, :point_right: **New** in System Variables frame and create a variable called JAVA_HOME containing the path that leads to where the JDK software is located (e.g. C:\Program Files\Java\jdk-11).
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, and then edit Path system variable with the new %JAVA_HOME%\bin entry.
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, and then edit Path user variable with the new C:\Program Files\Java\jdk-11 entry.
- See [Maven download page](https://maven.apache.org/download.cgi), download the xxxBinary zip archive and unzip it in a place of your preference (e.g. C:\Program Files\Maven\apache-maven-3.9.9).
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, :point_right: **New** in System Variables frame and create a variable called MAVEN_HOME containing the path that leads to where the JDK software is located (e.g. C:\Program Files\Maven\apache-maven-3.9.9).
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, and then edit Path system variable with the new %MAVEN_HOME%\bin entry.
  - Right click :point_right: **My Computer** and select :point_right: **Properties**. On the :point_right: **Advanced** tab, select :point_right: **Environment Variables**, and then edit Path user variable with the new %MAVEN_HOME%\bin entry.
- Open IntelliJ IDEA, hit :point_right: **New Project**, hit :point_right: **Java** in New Project frame, hit :point_right: **Maven** as Build system option and check the checkboxes below: 
  - :white_check_mark: **Add sample code**, 
  - :white_check_mark: **Generate code with onboarding tips**. 
Hit :point_right: **Create**. 
- Open IntelliJ IDEA, hit :point_right: **File**, hit :point_right: **Settings**, hit :point_right: **Plugins** and in the Marketplace tab, look for Karate and install the one from Karate Labs Inc.
- See [Karate JUnit 5](https://mvnrepository.com/artifact/com.intuit.karate/karate-junit5/1.3.1), copy the maven dependency code and paste it in the dependency tag. 
- See [Java Faker](https://mvnrepository.com/artifact/com.github.javafaker/javafaker/1.0.2), copy the maven dependency code and paste it in the dependency tag. 
- See [Apache Maven Compiler Plugin](https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-compiler-plugin/3.13.0), copy the maven dependency code and paste it in the dependency tag. 
- See [Maven Surefire Plugin](https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-surefire-plugin/3.5.3), copy the maven dependency code and paste it in the dependency tag. . Hit :point_right: **Sync maven changes**. Your dependency tag in the pom.xml file, now, should be something like:

  ```
    <dependencies>

        <!-- https://mvnrepository.com/artifact/com.intuit.karate/karate-junit5 -->
        <dependency>
            <groupId>com.intuit.karate</groupId>
            <artifactId>karate-junit5</artifactId>
            <version>1.3.1</version>
            <scope>test</scope>
        </dependency>

        <!-- https://mvnrepository.com/artifact/com.github.javafaker/javafaker -->
        <dependency>
            <groupId>com.github.javafaker</groupId>
            <artifactId>javafaker</artifactId>
            <version>1.0.2</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-surefire-plugin -->
        <dependency>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.5.3</version>
        </dependency>

        <!-- https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-compiler-plugin -->
        <dependency>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.13.0</version>
        </dependency>

    </dependencies>
  ``` 

# Tests:

- Open command prompt in the pom.xml directory (e.g. C:\Users\<user_name>\IdeaProjects\karate-expandtesting_api) and Execute ```mvn clean install``` to run all to removes previous build files while compiles the source code an execute the tests.
- Hit :point_right:**Testing** button on left side bar in IntelliJ and choose the tests to execute.

# Support:

- [Maven repositories](https://mvnrepository.com/)
- [Karate Framework Tutorial | Project Setup and Installation using Karate API Automation | Part 2](https://www.youtube.com/watch?v=8-SDRUUIqPM)
- [Package com.github.javafaker](https://javadoc.io/static/com.github.javafaker/javafaker/1.0.2/com/github/javafaker/package-summary.html)
- [ChatGPT](https://chatgpt.com/)

# Tips:

- When needed, open pom.xml directory and execute ```mvn clean install```. It removes previous build files to ensure a clean environment, while compiles the source code and runs tests to compile the automation again. 

