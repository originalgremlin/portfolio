!     
! File:   PiecewiseLinearInterpolation.f95
! Author: barry
!
! Created on January 21, 2011, 11:21 AM
!

module mPiecewiseLinearInterpolation
    use mInterpolation
    use mFunctionObject
    implicit none
    private

    type, public, extends(Interpolation) :: PiecewiseLinearInterpolation
        private
        ! precalculate the slope from x(i) to x(i+1) for use in valueAt
        real, dimension(:), allocatable :: slopes
    contains
        procedure :: init
        procedure :: initFromExisting
        procedure :: destroy
        procedure :: valueAt
        procedure :: calculateSlopes
    end type PiecewiseLinearInterpolation

contains
    subroutine init (this, valueFunc, lowerBound, upperBound, numNodes)
        implicit none
        class(PiecewiseLinearInterpolation) :: this
        class(FunctionObject), intent(in)   :: valueFunc
        real, intent(in)                    :: lowerBound
        real, intent(in)                    :: upperBound
        integer, intent(in)                 :: numNodes
        integer                             :: status
        ! store bounds
        this%lowerBound = min(lowerBound, upperBound)
        this%upperBound = max(lowerBound, upperBound)
        ! allocate arrays
        allocate(this%nodes(numNodes,2), this%slopes(numNodes-1), STAT=status)
        if (status /= 0) stop "Unable to allocate memory for PiecewiseLinearInterpolation arrays."
        ! place nodes
        call this%placeNodes(valueFunc)
        ! pre-calculate slopes
        call this%calculateSlopes()
    end subroutine init

    subroutine initFromExisting (this, points, values)
        implicit none
        class(PiecewiseLinearInterpolation) :: this
        real, dimension(:), intent(in)      :: points, values
        integer                             :: i, numNodes, status
        ! store bounds
        this%lowerBound = points(lbound(points,1))
        this%upperBound = points(ubound(points,1))
        ! allocate arrays
        numNodes = ubound(points,1) - lbound(points,1) + 1
        allocate(this%nodes(numNodes,2), this%slopes(numNodes-1), STAT=status)
        if (status /= 0) stop "Unable to allocate memory for PiecewiseLinearInterpolation arrays."
        ! place nodes
        call this%placeNodesFromExisting(points, values)
        ! pre-calculate slopes
        call this%calculateSlopes()
    end subroutine initFromExisting

    subroutine destroy (this)
        implicit none
        class(PiecewiseLinearInterpolation) :: this
        integer                             :: status
        if (allocated(this%nodes)) then
            deallocate(this%nodes, STAT=status)
            if (status /= 0) stop "Unable to deallocate memory for nodes."
        end if
        if (allocated(this%slopes)) then
            deallocate(this%slopes, STAT=status)
            if (status /= 0) stop "Unable to deallocate memory for slope."
        end if
    end subroutine destroy

    real function valueAt (this, xval)
        implicit none
        class(PiecewiseLinearInterpolation) :: this
        real, intent(in)                    :: xval
        integer                             :: lower
        ! find greatest node with xval < x
        lower = this%find(xval)
        ! return the estimated value of f(x)
        ! ~f(x) = nodeY + slope * (x - nodeX)
        valueAt = this%nodes(lower,2) + this%slopes(lower) * (xval - this%nodes(lower,1))
    end function valueAt

    subroutine calculateSlopes (this)
        implicit none
        class(PiecewiseLinearInterpolation) :: this
        integer                             :: i, n
        n = ubound(this%slopes, 1) - lbound(this%slopes, 1)
        do i = 1, n
            this%slopes(i) = (this%nodes(i+1,2) - this%nodes(i,2)) / (this%nodes(i+1,1) - this%nodes(i,1))
        end do
    end subroutine calculateSlopes
end module mPiecewiseLinearInterpolation
