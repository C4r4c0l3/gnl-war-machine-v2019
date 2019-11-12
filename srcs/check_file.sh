# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    check_file.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ahallain <ahallain@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/11/09 19:30:41 by ahallain          #+#    #+#              #
#    Updated: 2019/11/12 19:31:38 by ahallain         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

retval=1

check_file()
{
	printf "${COLOR_FUNC}BUFF_$1"
	printf "$> gcc -Wall -Werror -Wextra tests/main.c ${PATH_TEST}/get_next_line.c ${PATH_TEST}/get_next_line_utils.c -D BUFFER_SIZE=$1 -o BUFF_$1\n">>${PATH_DEEPTHOUGHT}/deepthought
	COMPIL_VAR=$(gcc -Wall -Werror -Wextra tests/main.c ${PATH_TEST}/get_next_line.c ${PATH_TEST}/get_next_line_utils.c -D BUFFER_SIZE=$1 -o BUFF_$1 2>&1)
	printf "\033[20G"
	if [[ $COMPIL_VAR =~ "error" ]]
		then
			printf "${COLOR_FAIL}missing"
			printf "\033[80GCompil. Failed${DEFAULT}"
			printf "$COMPIL_VAR" >>${PATH_DEEPTHOUGHT}/deepthought
			printf "Compil. Failed\n">>${PATH_DEEPTHOUGHT}/deepthought
		else
			printf "${COLOR_OK}ok${DEFAULT}"
			printf "\033[40G"
			printf "$> ./BUFF_$1 tests/file.txt 0\n">>${PATH_DEEPTHOUGHT}/deepthought
			retval=1
			for file in "${CHECK_FILES[@]}"
			do
				diff_check $1 $file
			done
			printf "\033[60G"
			if [ $LEAKS -eq 1 ]
			then
				LEAKS_CHECK=$(./BUFF_$1 tests/file.txt 1.5 | leaks BUFF_$1 2>&1)
				printf "$> ./BUFF_$1 tests/file.txt 1.5 | leaks BUFF_$1\n" >> ${PATH_DEEPTHOUGHT}/deepthought
				if [[ $LEAKS_CHECK =~ "0 leaks" ]]
				then
					printf "\nLEAKS OK :D\n" >> ${PATH_DEEPTHOUGHT}/deepthought
					printf "${COLOR_OK}ok${DEFAULT}"
				else
					echo "${LEAKS_CHECK}" | cat -e >> ${PATH_DEEPTHOUGHT}/deepthought
					printf "\nLEAKS KO :(\n" >> ${PATH_DEEPTHOUGHT}/deepthought
					printf "${COLOR_FAIL}missing"
					retval=0
				fi
			else
				printf "${COLOR_WARNING}check removed${DEFAULT}"
			fi
			printf "\033[80G"
			if [ $retval -eq 1 ]
			then
				printf "${COLOR_OK}ok${DEFAULT}"
			else
				printf "${COLOR_FAIL}missing${DEFAULT}"
			fi
			rm ./BUFF_$1
	fi
	printf "${DEFAULT}"
}

diff_check ()
{
	RESULT_VAR=$(${PATH_TEST}/BUFF_$1 ${PATH_TEST}/tests/$2 0 >${PATH_TEST}/tests/user_output_buff_$1_$2 2>&1)
	DEFAULT_OUTPUT=${PATH_TEST}/tests/default_$2.output
	if (( $1 <= 0 ))
	then
		DEFAULT_OUTPUT=${PATH_TEST}/tests/buff_$1.output
	else
		if [ ! -f "$DEFAULT_OUTPUT" ]
		then
			printf "$> cp ${PATH_TEST}/tests/$2 $DEFAULT_OUTPUT\n" >> ${PATH_DEEPTHOUGHT}/deepthought
			cp ${PATH_TEST}/tests/$2 $DEFAULT_OUTPUT
			echo "" >> $DEFAULT_OUTPUT
		fi
	fi
	printf "$> diff -U 3 ${PATH_TEST}/tests/user_output_buff_$1_$2 $DEFAULT_OUTPUT\n" >> ${PATH_DEEPTHOUGHT}/deepthought
	DIFF=$(diff -U 3 ${PATH_TEST}/tests/user_output_buff_$1_$2 $DEFAULT_OUTPUT 2>&1)
	if [ "$DIFF" != "" ]
	then
		echo "${DIFF}" | cat -e >> ${PATH_DEEPTHOUGHT}/deepthought
		printf "\nDiff KO :(\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		printf "${COLOR_FAIL}✗${DEFAULT}"
		retval=0
	else
		printf "\nDiff OK :D\n" >> ${PATH_DEEPTHOUGHT}/deepthought
		printf "${COLOR_OK}✓${DEFAULT}"
	fi
}