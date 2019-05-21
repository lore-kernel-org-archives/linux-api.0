From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/2] open: add close_range()
Date: Tue, 21 May 2019 15:39:53 +0200
Message-ID: <82d34133-e174-efc3-48ed-332304028595@rasmusvillemoes.dk>
References: <20190521113448.20654-1-christian@brauner.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190521113448.20654-1-christian@brauner.io>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 21/05/2019 13.34, Christian Brauner wrote:

> The performance is striking. For good measure, comparing the following
> simple close_all_fds() userspace implementation that is essentially just
> glibc's version in [6]:
> 
> static int close_all_fds(void)
> {
>         DIR *dir;
>         struct dirent *direntp;
> 
>         dir = opendir("/proc/self/fd");
>         if (!dir)
>                 return -1;
> 
>         while ((direntp = readdir(dir))) {
>                 int fd;
>                 if (strcmp(direntp->d_name, ".") == 0)
>                         continue;
>                 if (strcmp(direntp->d_name, "..") == 0)
>                         continue;
>                 fd = atoi(direntp->d_name);
>                 if (fd == 0 || fd == 1 || fd == 2)
>                         continue;
>                 close(fd);
>         }
> 
>         closedir(dir); /* cannot fail */
>         return 0;
> }

Before anybody copy-pastes this, please note that it lacks a check for
fd == dirfd(dir). If all of /proc/self/fd is returned in the first
getdents() syscall one won't notice, but...

Rasmus
