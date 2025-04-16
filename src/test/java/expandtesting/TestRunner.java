package expandtesting;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate runAllTests() {
        return Karate.run("Health", "Users").relativeTo(getClass());
    }
}
