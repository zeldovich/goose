From RecoveryRefinement Require Import Database.CodeSetup.

Definition Empty  : proc unit :=
  Ret tt.

Definition EmptyReturn  : proc unit :=
  Ret tt.

Module allTheLiterals.
  Record t := mk {
    int: uint64;
    s: Path;
    b: bool;
  }.
  Global Instance t_zero : HasGoZero t := mk (zeroValue _) (zeroValue _) (zeroValue _).
End allTheLiterals.

Definition normalLiterals  : proc allTheLiterals.t :=
  Ret {| allTheLiterals.int := 0;
         allTheLiterals.s := "foo";
         allTheLiterals.b := true; |}.

Definition specialLiterals  : proc allTheLiterals.t :=
  Ret {| allTheLiterals.int := 4096;
         allTheLiterals.s := "";
         allTheLiterals.b := false; |}.

Definition oddLiterals  : proc allTheLiterals.t :=
  Ret {| allTheLiterals.int := fromNum 5;
         allTheLiterals.s := "backquote string";
         allTheLiterals.b := false; |}.

Definition DoSomeLocking (l:LockRef) : proc unit :=
  _ <- Data.lockAcquire Writer l;
  _ <- Data.lockRelease Writer l;
  _ <- Data.lockAcquire Reader l;
  _ <- Data.lockAcquire Reader l;
  _ <- Data.lockRelease Reader l;
  Data.lockRelease Reader l.

Definition MakeLock  : proc unit :=
  l <- Data.newLock;
  DoSomeLocking l.
