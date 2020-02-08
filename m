From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -manpage 2/2] memfd_create.2: Update manpage with new
 memfd F_SEAL_FUTURE_WRITE seal
Date: Sat, 8 Feb 2020 12:58:33 +0100
Message-ID: <3349d0f2-6ea0-4e3a-1d9b-5a105edc34c8@gmail.com>
References: <20190314214844.207430-1-joel@joelfernandes.org>
 <20190314214844.207430-3-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190314214844.207430-3-joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Joel Fernandes (Google)" <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dancol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Jann Horn <jannh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Joel,

On 3/14/19 10:48 PM, Joel Fernandes (Google) wrote:
> More details of the seal can be found in the LKML patch:
> https://lore.kernel.org/lkml/20181120052137.74317-1-joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org/T/#t
> 
> Signed-off-by: Joel Fernandes (Google) <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>

Thanks! Patch applied

Cheers,

Michael



> ---
>  man2/memfd_create.2 | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/man2/memfd_create.2 b/man2/memfd_create.2
> index 15b1362f5525..3b7f032407ed 100644
> --- a/man2/memfd_create.2
> +++ b/man2/memfd_create.2
> @@ -280,7 +280,15 @@ in order to restrict further modifications on the file.
>  (If placing the seal
>  .BR F_SEAL_WRITE ,
>  then it will be necessary to first unmap the shared writable mapping
> -created in the previous step.)
> +created in the previous step. Otherwise, behavior similar to
> +.BR F_SEAL_WRITE
> +can be achieved, by using
> +.BR F_SEAL_FUTURE_WRITE
> +which will prevent future writes via
> +.BR mmap (2)
> +and
> +.BR write (2)
> +from succeeding, while keeping existing shared writable mappings).
>  .IP 4.
>  A second process obtains a file descriptor for the
>  .BR tmpfs (5)
> @@ -425,6 +433,7 @@ main(int argc, char *argv[])
>          fprintf(stderr, "\et\etg \- F_SEAL_GROW\en");
>          fprintf(stderr, "\et\ets \- F_SEAL_SHRINK\en");
>          fprintf(stderr, "\et\etw \- F_SEAL_WRITE\en");
> +        fprintf(stderr, "\et\etW \- F_SEAL_FUTURE_WRITE\en");
>          fprintf(stderr, "\et\etS \- F_SEAL_SEAL\en");
>          exit(EXIT_FAILURE);
>      }
> @@ -463,6 +472,8 @@ main(int argc, char *argv[])
>              seals |= F_SEAL_SHRINK;
>          if (strchr(seals_arg, \(aqw\(aq) != NULL)
>              seals |= F_SEAL_WRITE;
> +        if (strchr(seals_arg, \(aqW\(aq) != NULL)
> +            seals |= F_SEAL_FUTURE_WRITE;
>          if (strchr(seals_arg, \(aqS\(aq) != NULL)
>              seals |= F_SEAL_SEAL;
>  
> @@ -518,6 +529,8 @@ main(int argc, char *argv[])
>          printf(" GROW");
>      if (seals & F_SEAL_WRITE)
>          printf(" WRITE");
> +    if (seals & F_SEAL_FUTURE_WRITE)
> +        printf(" FUTURE_WRITE");
>      if (seals & F_SEAL_SHRINK)
>          printf(" SHRINK");
>      printf("\en");
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
