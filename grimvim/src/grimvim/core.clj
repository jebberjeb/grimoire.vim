(ns grimvim.core)

(defn get-maven-info
  [ns-str]
  (let [code-url (->> ns-str
                      symbol
                      ns-publics
                      (map (comp var-get val))
                      ;; Find the first function of the namespace. We want a
                      ;; var who's value will be an instance of a class from
                      ;; the jar which contains the namespace.
                      (filter fn?)
                      first
                      .getClass
                      .getProtectionDomain
                      .getCodeSource
                      .getLocation)
        jar (java.util.jar.JarFile. (.getPath code-url))
        entries (enumeration-seq (.entries jar))
        entry (filter #(.contains (.getName %) "pom.properties") entries)]
    (into {}
          (doto (java.util.Properties.)
            (.load (.getInputStream jar (first entry)))))))
