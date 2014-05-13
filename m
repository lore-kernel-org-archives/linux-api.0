From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] mem.4, ioports.4: Document /dev/ioports
Date: Tue, 13 May 2014 10:27:10 +0200
Message-ID: <CAKgNAkiPRnQRE6ovEXsPOsSagMGC-3xM38G8WRRHg+4iKiQuYQ@mail.gmail.com>
References: <20140509191914.GA7286@jtriplet-mobl1> <20140509192126.GA13050@jtriplet-mobl1>
Reply-To: mtk.manpages@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140509192126.GA13050@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-man <linux-man@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Josh,

On Fri, May 9, 2014 at 9:21 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> /dev/ioports works like /dev/port, but supports 16-bit and 32-bit ports.
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>
> Wasn't sure whether I should update the "Modified" notice at the top;
> ideally such things should go away in favor of git.

Mostly they do go away with Git, but I do add Copyright notices when
the changes to the page are substantial (as here).

Could you ping me again if/when this looks like heading to mainline?

Thanks,

Michael



>
>  man4/ioports.4 |  1 +
>  man4/mem.4     | 21 +++++++++++++++++++--
>  2 files changed, 20 insertions(+), 2 deletions(-)
>  create mode 100644 man4/ioports.4
>
> diff --git a/man4/ioports.4 b/man4/ioports.4
> new file mode 100644
> index 0000000..d4c1762
> --- /dev/null
> +++ b/man4/ioports.4
> @@ -0,0 +1 @@
> +.so man4/mem.4
> diff --git a/man4/mem.4 b/man4/mem.4
> index 74b7b89..adfd810 100644
> --- a/man4/mem.4
> +++ b/man4/mem.4
> @@ -25,7 +25,7 @@
>  .\" Modified Sat Jul 24 16:59:10 1993 by Rik Faith (faith@cs.unc.edu)
>  .TH MEM 4 1992-11-21 "Linux" "Linux Programmer's Manual"
>  .SH NAME
> -mem, kmem, port \- system memory, kernel memory and system ports
> +mem, kmem, port, ioports \- system memory, kernel memory and system ports
>  .SH DESCRIPTION
>  .B mem
>  is a character device file
> @@ -66,7 +66,8 @@ chown root:kmem /dev/kmem
>  .B port
>  is similar to
>  .BR mem ,
> -but the I/O ports are accessed.
> +but the I/O ports are accessed.  Multi-byte reads or writes to port will
> +operate on successive byte-sized ports.
>  .LP
>  It is typically created by:
>  .RS
> @@ -75,12 +76,28 @@ mknod \-m 660 /dev/port c 1 4
>  .br
>  chown root:mem /dev/port
>  .RE
> +.LP
> +.B ioports
> +is similar to
> +.BR port ,
> +but supports reads and writes of 16-bit or 32-bit ports.  Reads or writes to
> +ioport with sizes other than 1, 2, or 4 will return EINVAL.
> +.LP
> +It is typically created by:
> +.RS
> +.sp
> +mknod \-m 660 /dev/ioports c 1 12
> +.br
> +chown root:mem /dev/ioports
> +.RE
>  .SH FILES
>  .I /dev/mem
>  .br
>  .I /dev/kmem
>  .br
>  .I /dev/port
> +.br
> +.I /dev/ioports
>  .SH SEE ALSO
>  .BR chown (1),
>  .BR mknod (1),
> --
> 2.0.0.rc2
>



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
