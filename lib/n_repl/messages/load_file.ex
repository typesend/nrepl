defmodule NRepl.Messages.LoadFile do
  import UUID, only: [uuid4: 0]

  defstruct op: "load-file",
            file: nil,
            id: UUID.uuid4(),
            # Name of source file, e.g. io.clj
            file_name: nil,
            # Source-path-relative path of the source file, e.g. clojure/java/io.clj
            file_path: nil,
            # A fully-qualified symbol naming a var whose function to use to convey interactive errors. Must point to a function that takes a java.lang.Throwable as its sole argument.
            "nrepl.middleware.caught/caught": nil,
            # If logical true, the printed value of any interactive errors will be returned in the response (otherwise they will be elided). Delegates to nrepl.middleware.print to perform the printing. Defaults to false.
            "nrepl.middleware.caught/print?": nil,
            # The size of the buffer to use when streaming results. Defaults to 1024.
            "nrepl.middleware.print/buffer-size": nil,
            # A seq of the keys in the response whose values should be printed.
            "nrepl.middleware.print/keys": nil,
            # A map of options to pass to the printing function. Defaults to nil.
            "nrepl.middleware.print/options": nil,
            # A fully-qualified symbol naming a var whose function to use for printing. Must point to a function with signature [value writer options].
            "nrepl.middleware.print/print": nil,
            # A hard limit on the number of bytes printed for each value.
            "nrepl.middleware.print/quota": nil,
            # If logical true, the result of printing each value will be streamed to the client over one or more messages.
            "nrepl.middleware.print/stream?": nil

  # session: nil, ???????????

  def required(), do: [:file]
end
