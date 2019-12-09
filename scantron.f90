program main
    implicit none
    integer, parameter  :: max_question = 50
    integer, parameter  :: file_unit = 10

    integer:: i, size, score, sum
    real    :: avg
    integer :: ios = 0
    integer :: line = 0
    character(len=50) id
    integer, dimension(max_question)    :: answer, array
    integer, dimension(0: 100)          :: score_map

    do i = 0, 100
        score_map(i) = 0
    end do

    open(file_unit, file='scantron.txt', status='old')
    read(file_unit, *, iostat=ios) size

    call get_array(size, line, ios, id, array)
    answer = array
    write (*, '(A5, A10)') 'Student Id', 'Score'
    write(*, '(A)') repeat('=', 15)

    line = 1

    do while (ios == 0)
        call get_array(size, line, ios, id, array)
        if (ios == 0) then
            score = get_score(size, answer, array)
            score_map(score) = score_map(score) + 1
            write(*, '(A5, I10)') id, score
            line = line + 1
        end if
    end do

    write(*, '(A)') repeat('=', 15)
    write(*, '(A, I3)') 'Tests graded = ', line - 1
    write(*, '(A)') repeat('=', 15)
    write (*, '(A, A10)') 'Score', 'Frequency'
    write(*, '(A)') repeat('=', 15)

    sum = 0
    do i = 100, 0, -1
        if (score_map(i) .ne. 0) then
            sum = sum + i * score_map(i)
            write (*, '(I3, I10)') i, score_map(i)
        end if
    end do
    write(*, '(A)') repeat('=', 15)
    avg = sum / line
    write(*, '(A, 5f5.2)') 'Class Average = ', avg


contains
    subroutine get_array(size, line, ios, id, array)
        implicit none
        integer, intent(in) :: size, line
        integer, intent(inout)  :: ios
        character(len=10), intent(out)  :: id
        integer, dimension(size), intent(out)   :: array

        if (line == 0) then
            read(file_unit, *, iostat=ios) (array(i), i=1, size)
        else
            read(file_unit, *, iostat=ios) id, (array(i), i=1, size)
        end if

    end subroutine get_array

    function get_score(size, answer, response) result (score)
        implicit none
        integer             :: score, i
        integer, intent(in) :: size
        integer, dimension(size)    :: answer, response

        score = 0
        do i = 1, size
            if (answer(i) .eq. response(i)) then
                score = score + 1
            end if
        end do

        score = 100 / size * score

    end function get_score
end program
