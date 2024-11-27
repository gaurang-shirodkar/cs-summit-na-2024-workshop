package lambda

import future.keywords.in

allowed_runtimes := {"python3.9", "python3.10"}

default runtime_allowed := false

runtime_allowed = true {
  input.Runtime in allowed_runtimes
}
