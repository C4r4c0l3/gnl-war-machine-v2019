/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: ahallain <ahallain@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2019/11/09 19:32:06 by ahallain          #+#    #+#             */
/*   Updated: 2019/11/12 19:32:02 by ahallain         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <fcntl.h>
#include "gnl.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int		main(int argc, char **argv)
{
	int		fd;
	int		ret;
	char	*line;

	if (argc < 3)
		return (0);
	fd = open(argv[1], O_RDONLY);
	if (fd == -1)
		return (-1);
	ret = 1;
	while (ret > 0)
	{
		ret = get_next_line(fd, &line);
		printf("%s\n", line);
		free(line);
	}
	close(fd);
	sleep(atoi(argv[2]));
	return (1);
}