package cu.limitexpert.utils;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class PrologUtils {

    public static void consult(String route) {
        Query q = new Query("consult", new Term[] {new Atom(route)});
        q.hasSolution();
    }

    public static String derivar(String function, String variable) {
        String result = "";
        Query query = new Query(MessageFormat.format("derivar({0}, {1}, D, _)", function, variable));
        if (query.hasSolution()) {
            // Obtener la solución de la consulta
            Map<String, Term> solution = query.oneSolution();

            // Obtener el término que representa la función derivada
            Term derivada = solution.get("D");

            // Convertir el valor en una cadena de texto
            result = termToString(derivada);
        }
        query.close();
        return result;
    }

    public static List<List<String>> derivadaPasos(String function, String variable) {
        List<List<String>> result = new ArrayList<>();
        Query query = new Query(MessageFormat.format("derivar({0}, {1}, D, P)", function, variable));
        if (query.hasSolution()) {
            // Obtener la solución de la consulta
            Map<String, Term> solution = query.oneSolution();

            // Obtener el término que representa la función derivada
            Term pasos = solution.get("P");
            result = tupleListToString(pasos);
        }
        query.close();
        return result;
    }

    public static String limite(String function, String value) {
        String result = "";
        Query query = new Query(MessageFormat.format("limite({0}, x, {1}, L, _)", function, value));
        if (query.hasSolution()) {
            Map<String, Term> solution = query.oneSolution();
            Term limite = solution.get("L");
            result = termToString(limite);
        }
        query.close();
        return result;
    }

    public static List<List<String>> limitePasos(String function, String value) {
        List<List<String>> result = new ArrayList<>();
        Query query = new Query(MessageFormat.format("limite({0}, x, {1}, L, P)", function, value));
        if (query.hasSolution()) {
            Map<String, Term> solution = query.oneSolution();
            Term limite = solution.get("P");
            result = tupleListToString(limite);
        }
        query.close();
        return result;
    }

    public static List<String> getDerivationRules(){
        List<String> result = new ArrayList<>();

        Query query = new Query("obtener_reglas(R)");
        if (query.hasSolution()) {
            Map<String, Term> solution = query.oneSolution();
            Term reglas = solution.get("R");
            result = listToString(reglas);
        }
        query.close();
        return result;
    }


    private static List<String> listToString(Term term) {
        List<String> result = new ArrayList<>();

        if (term.isList()) {
            Term[] list = term.listToTermArray();
            for (Term t : list) {
                result.add(termToString(t));
            }
        }

        return result;
    }

    private static List<List<String>> tupleListToString(Term term) {
        List<List<String>> result = new ArrayList<>();

        if (term.isList()) {
            Term[] list = term.listToTermArray();
            for (Term t : list) {
                result.add(tupleToString(t));
            }
        }

        return result;
    }

    private static List<String> tupleToString(Term term) {
        List<String> result = new ArrayList<>();

        if (term.arity() == 2) {
            Term arg1 = term.arg(1);
            Term arg2 = term.arg(2);
            result.add(termToString(arg1));
            result.add(termToString(arg2));
        }

        return result;
    }


    private static String termToString(Term term) {
        if (term.isCompound()) {
            String functor = term.name();
            Term[] args = term.args();

            switch (functor) {
                case "+" -> {
                    return termToString(args[0]) + " + " + termToString(args[1]);
                }
                case "-" -> {
                    if (args.length == 1) {
                        return "-(" + termToString(args[0]) + ")";
                    } else {
                        return "(" + termToString(args[0]) + ") - (" + termToString(args[1]) + ")";
                    }
                }
                case "*" -> {
                    return "(" + termToString(args[0]) + ")" + " * (" + termToString(args[1]) + ")";
                }
                case "/" -> {
                    return "(" + termToString(args[0])  + ") / (" + termToString(args[1]) + ")";
                }
                case "^" -> {
                    return "(" + termToString(args[0]) + ") ^ (" +termToString(args[1]) + ")";
                }
                case "sen" -> {
                    return "sen(" + termToString(args[0]) + ")";
                }
                case "cos" -> {
                    return "cos(" + termToString(args[0]) + ")";
                }
                case "tan" -> {
                    return "tan(" + termToString(args[0]) + ")";
                }
                case "log" -> {
                    return "log(" + termToString(args[0]) + ")";
                }
                case "ln" -> {
                    return "ln(" + termToString(args[0]) + ")";
                }
                default -> {
                    return functor + "(" + termToString(args[0]) + ")";
                }
                //más casos para otros operadores si es necesario
            }
        } else if (term.isVariable() || term.isAtom()) {
            return term.name();
        } else {
            return term.toString();
        }
    }


    public static void main(String[] args) {
        consult("src/main/prolog/derivador.pl");
        System.out.println(derivar("x", "x"));
    }

}

