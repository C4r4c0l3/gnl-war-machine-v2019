/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ahallain <ahallain@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/11/09 19:32:06 by ahallain          #+#    #+#             */
/*   Updated: 2019/11/13 18:57:18 by ahallain         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <fcntl.h>
#include "gnl.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

int		main(int argc, char **argv)
{
	int		fd;
	int		ret;
	char	*line;
	int		ex;
	char	*leaks;

	if (argc < 3)
		return (0);
	ex = atoi(argv[2]);
	fd = open(argv[1], O_RDONLY);
	if (fd == -1)
		return (-1);
	ret = 1;
	while (ret > 0)
	{
		ret = get_next_line(fd, &line);
		if (!ex)
			printf("%s\n", line);
		free(line);
	}
	close(fd);
	if (ex) {
		if (!(leaks = malloc(7)))
			return (2);
		leaks[0] = 'l';
		leaks[1] = 'e';
		leaks[2] = 'a';
		leaks[3] = 'k';
		leaks[4] = 's';
		leaks[5] = ' ';
		ex = 2;
		while (argv[0][ex])
		{
			leaks[ex + 4] = argv[0][ex];
			ex++;
		}
		leaks[ex + 4] = 0;
		system(leaks);
	}
	return (1);
}