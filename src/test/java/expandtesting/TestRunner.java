package expandtesting;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    // ✅ Roda todos os testes normalmente (sem filtro de tags)
    @Karate.Test
    Karate runAllTests() {
        return Karate.run("Health", "Users", "Notes").relativeTo(getClass());
    }

    // ✅ Roda SOMENTE testes marcados com @negative em qualquer feature
//    @Karate.Test
//    Karate runOnlyNegatives() {
//        return Karate.run().tags("@negative").relativeTo(getClass());
//    }

    // ✅ Roda TODOS os testes EXCETO os negativos (remove @negative)
//    @Karate.Test
//    Karate runExcludingNegatives() {
//        return Karate.run().tags("~@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Users
//    @Karate.Test
//    Karate runOnlyUsers() {
//        return Karate.run().tags("@users").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes negativos dentro da feature Users
//    @Karate.Test
//    Karate runOnlyUsersNegatives() {
//        return Karate.run().tags("@users", "@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Users EXCLUINDO os negativos
//    @Karate.Test
//    Karate runOnlyUsersExcludingNegatives() {
//        return Karate.run().tags("@users", "~@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Notes
//    @Karate.Test
//    Karate runOnlyNotes() {
//        return Karate.run().tags("@notes").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes negativos dentro da feature Notes
//    @Karate.Test
//    Karate runOnlyNotesNegatives() {
//        return Karate.run().tags("@notes", "@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Notes EXCLUINDO os negativos
//    @Karate.Test
//    Karate runOnlyNotesExcludingNegatives() {
//        return Karate.run().tags("@notes", "~@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Health
//    @Karate.Test
//    Karate runOnlyHealth() {
//        return Karate.run().tags("@health").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes negativos da feature Health
//    @Karate.Test
//    Karate runOnlyHealthNegatives() {
//        return Karate.run().tags("@health", "@negative").relativeTo(getClass());
//    }

    // ✅ Roda SOMENTE os testes da feature Health EXCLUINDO os negativos
//    @Karate.Test
//    Karate runOnlyHealthExcludingNegatives() {
//        return Karate.run().tags("@health", "~@negative").relativeTo(getClass());
//    }
}
