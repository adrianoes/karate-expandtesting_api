package utils;

import com.github.javafaker.Faker;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public class FakerUtils {
    private static final Faker faker = new Faker(new Locale("en"));

    public static Map<String, Object> generateUserData() {
        Map<String, Object> userData = new HashMap<>();
        userData.put("name", faker.name().fullName());
        userData.put("email", faker.regexify("[0-9]{3,5}") + faker.internet().emailAddress().toLowerCase().replace("-", ""));
        userData.put("password", faker.regexify("[A-Za-z0-9]{12,20}"));
        userData.put("updatedName", faker.name().fullName());
        userData.put("phone", faker.regexify("[0-9]{10,12}"));
        userData.put("company", faker.regexify("[A-Za-z0-9]{5,15}"));
        userData.put("updatedPassword", faker.regexify("[A-Za-z0-9]{12,20}"));
        userData.put("noteTitle", "1234" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteDescription", "1234" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteCategory", faker.options().option("Home", "Personal", "Work"));
        userData.put("noteUpdatedTitle", "1234" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteUpdatedDescription", "1234" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteUpdatedCategory", faker.options().option("Home", "Personal", "Work"));
        userData.put("noteUpdatedCompleted", true);
        userData.put("noteTitle2", "5678" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteDescription2", "5678" + faker.rockBand().name().replaceAll("[^a-zA-Z0-9 ]", ""));
        userData.put("noteCategory2", faker.options().option("Home", "Personal", "Work"));

        return userData;
    }
}
