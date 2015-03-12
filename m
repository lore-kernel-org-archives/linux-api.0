From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 13/14] kdbus: add walk-through user space example
Date: Thu, 12 Mar 2015 10:52:56 -0400
Message-ID: <5501A848.5080402@oracle.com>
References: <1425906560-13798-1-git-send-email-gregkh@linuxfoundation.org> <1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425906560-13798-14-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de, ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no, jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel@zonque.org, dh.herrmann@gmail.com, tixxdz@opendz.org
List-Id: linux-api@vger.kernel.org

On 03/09/2015 09:09 AM, Greg Kroah-Hartman wrote:
> diff --git a/samples/kdbus/Makefile b/samples/kdbus/Makefile
> new file mode 100644
> index 000000000000..d009025369f4
> --- /dev/null
> +++ b/samples/kdbus/Makefile
> @@ -0,0 +1,10 @@
> +# kbuild trick to avoid linker error. Can be omitted if a module is built.
> +obj- := dummy.o
> +
> +hostprogs-y += kdbus-workers
> +
> +always := $(hostprogs-y)
> +
> +HOSTCFLAGS_kdbus-workers.o +=		\
> +	-I$(objtree)/usr/include/	\
> +	-I$(objtree)/include/uapi/
	-lrt

For older glibcs, otherwise clock_gettime() isn't found on linking.


Thanks,
Sasha
