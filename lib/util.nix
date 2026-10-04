{
  assertMsg =
    cond: value: msg:
    if cond then value else throw msg;
}
