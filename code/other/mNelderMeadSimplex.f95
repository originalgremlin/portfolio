!     
! File:   NelderMeadSimplex.f95
! Author: barry
!
! Created on January 21, 2011, 12:06 PM
!

module mNelderMeadSimplex
    use mOptimization
    use mFunctionObject
    use mVertex
    use mSimplex
    implicit none
    private

    type, public, extends(Optimization) :: NelderMeadSimplex
    contains
        procedure :: minimize
    end type NelderMeadSimplex

contains
    function minimize (this, valueFunc, guess, epsilon)
        implicit none
        class(NelderMeadSimplex)          :: this
        class(FunctionObject), intent(in) :: valueFunc
        real, dimension(:), intent(in)    :: guess
        real, intent(in)                  :: epsilon
        real, dimension(size(guess))      :: minimize
        
        type(Simplex)                     :: s
        type(Vertex)                      :: worst, fauxroid, reflection, expansion, contraction, centroid
        integer                           :: n

        ! these parameters are decent defaults
        ! other values within a small range lead sometimes to fewer and sometimes to more simplex moves
        ! the number of moves seems more heavily dependent on the starting guess than these parameters
        real, parameter                   :: ALPHA = 1.0 ! ALPHA > 0.0          default 1.0     reflection
        real, parameter                   :: GAMMA = 1.0 ! GAMMA > 0.0          default 1.0     expansion
        real, parameter                   :: BETA  = 0.5 ! 0.0 < BETA < 1.0     default 0.5     contraction
        real, parameter                   :: TAO   = 0.5 ! 0.0 < TAO < 1.0      default 0.5     shrinkage

        ! Step 1: construct the simplex
        call s%init(valueFunc, guess)
        n = size(s%vertices)

        ! allocate memory for temporary vertices
        call worst%init(valueFunc, s%vertices(1)%dims)
        call fauxroid%init(valueFunc, s%vertices(1)%dims)
        call reflection%init(valueFunc, s%vertices(1)%dims)
        call expansion%init(valueFunc, s%vertices(1)%dims)
        call contraction%init(valueFunc, s%vertices(1)%dims)
        call centroid%init(valueFunc, s%vertices(1)%dims)

        this%count = 0
        do
            ! reorder and continue walking the simplex
            call s%sort()

            ! exit if the simplex is small enough
            if (s%getWidth() < epsilon) exit
            
            ! Step 2: reflect the worst, which is the last vertex of a sorted simplex
            call s%copy(worst, n)
            call s%getFauxroid(fauxroid, n)
            call s%getReflection(reflection, worst, fauxroid, ALPHA)

            ! Step 2a: the reflection is now the best! expand towards it.
            if (reflection%val < s%vertices(1)%val) then
                call s%getExpansion(expansion, reflection, fauxroid, GAMMA)
                if (expansion%val < reflection%val) then
                    call s%replace(expansion, n)
                else
                    call s%replace(reflection, n)
                end if

            ! Step 2b: the reflection is better than at least one other vertex. replace worst.
            else if (reflection%val < s%vertices(n-1)%val) then
                call s%replace(reflection, n)

            ! Step 2c: the reflection is still the worst vertex. contract away from it.
            else
                if (reflection%val < worst%val) then
                    call s%getContraction(contraction, reflection, fauxroid, BETA)
                else
                    call s%getContraction(contraction, worst, fauxroid, BETA)
                end if
                if (contraction%val < worst%val) then
                    call s%replace(contraction, n)
                else
                    call s%shrink(TAO)
                end if
            end if

            ! update cycle count for 
            this%count = this%count + 1
        end do

        ! return the minimum
        minimize = s%vertices(1)%dims

        ! do cleanup
        call worst%destroy()
        call fauxroid%destroy()
        call reflection%destroy()
        call expansion%destroy()
        call contraction%destroy()
        call centroid%destroy()
        call s%destroy()
    end function minimize
end module mNelderMeadSimplex
