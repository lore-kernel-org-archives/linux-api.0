From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH -manpage 1/2] fcntl.2: Update manpage with new memfd
 F_SEAL_FUTURE_WRITE seal
Date: Sat, 8 Feb 2020 12:58:07 +0100
Message-ID: <11efee1c-0b65-2e51-0aa6-7f61fd2958c5@gmail.com>
References: <20190314214844.207430-1-joel@joelfernandes.org>
 <20190314214844.207430-2-joel@joelfernandes.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20190314214844.207430-2-joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>
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

Thanks. Patch (finally) applied!

Cheers,

Michael


> ---
>  man2/fcntl.2 | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/man2/fcntl.2 b/man2/fcntl.2
> index fce4f4c2b3bd..e01e2c075b5b 100644
> --- a/man2/fcntl.2
> +++ b/man2/fcntl.2
> @@ -1525,6 +1525,21 @@ Furthermore, if there are any asynchronous I/O operations
>  .RB ( io_submit (2))
>  pending on the file,
>  all outstanding writes will be discarded.
> +.TP
> +.BR F_SEAL_FUTURE_WRITE
> +If this seal is set, the contents of the file can be modified only from
> +existing writeable mappings that were created prior to the seal being set.
> +Any attempt to create a new writeable mapping on the memfd via
> +.BR mmap (2)
> +will fail with
> +.BR EPERM.
> +Also any attempts to write to the memfd via
> +.BR write (2)
> +will fail with
> +.BR EPERM.
> +This is useful in situations where existing writable mapped regions need to be
> +kept intact while preventing any future writes. For example, to share a
> +read-only memory buffer to other processes that only the sender can write to.
>  .\"
>  .SS File read/write hints
>  Write lifetime hints can be used to inform the kernel about the relative
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
