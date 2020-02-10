From: Damien Le Moal <Damien.LeMoal-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH 1/1] prctl.2: doc PR_SET/GET_IO_FLUSHER
Date: Mon, 10 Feb 2020 23:45:13 +0000
Message-ID: <BYAPR04MB581696DC573970197C98FA0FE7190@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20200210221557.8021-1-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "mhocko-IBi9RG/b67k@public.gmane.org" <mhocko-IBi9RG/b67k@public.gmane.org>, Masato Suzuki <masato.suzuki-Sjgp3cTcYWE@public.gmane.org>, "darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org" <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "bvanassche-HInyCGIudOg@public.gmane.org" <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 2020/02/11 7:16, Mike Christie wrote:=0A=
> This patch documents the PR_SET_IO_FLUSHER and PR_GET_IO_FLUSHER=0A=
> prctl commands added to the linux kernel for 5.6 in commit:=0A=
> =0A=
> commit 8d19f1c8e1937baf74e1962aae9f90fa3aeab463=0A=
> Author: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=0A=
> Date:   Mon Nov 11 18:19:00 2019 -0600=0A=
> =0A=
>     prctl: PR_{G,S}ET_IO_FLUSHER to support controlling memory reclaim=0A=
> =0A=
> Signed-off-by: Mike Christie <mchristi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=0A=
> ---=0A=
> =0A=
> V2:=0A=
> - My initial patch for this was very bad. This version is almost 100%=0A=
> taken word for word from Dave Chinner's review comments.=0A=
> =0A=
> =0A=
>  man2/prctl.2 | 25 +++++++++++++++++++++++++=0A=
>  1 file changed, 25 insertions(+)=0A=
> =0A=
> diff --git a/man2/prctl.2 b/man2/prctl.2=0A=
> index 720ec04e4..b481d186b 100644=0A=
> --- a/man2/prctl.2=0A=
> +++ b/man2/prctl.2=0A=
> @@ -1381,6 +1381,30 @@ system call on Tru64).=0A=
>  for information on versions and architectures.)=0A=
>  Return unaligned access control bits, in the location pointed to by=0A=
>  .IR "(unsigned int\ *) arg2" .=0A=
> +.TP=0A=
> +.B PR_SET_IO_FLUSHER (Since Linux 5.6)=0A=
> +An IO_FLUSHER is a user process that the kernel uses to issue IO=0A=
> +that cleans dirty page cache data and/or filesystem metadata. The=0A=
> +kernel may need to clean this memory when under memory pressure in=0A=
> +order to free it. This means there is potential for a memory reclaim=0A=
> +recursion deadlock if the user process attempts to allocate memory=0A=
> +and the kernel then blocks waiting for it to clean memory before it=0A=
> +can make reclaim progress.=0A=
> +=0A=
> +The kernel avoids these recursion problems internally via a special=0A=
> +process state that prevents recursive reclaim from issuing new IO.=0A=
> +If \fIarg2\fP is 1, the \fPPR_SET_IO_FLUSHER\fP control allows a userspa=
ce=0A=
> +process to set up this same process state and hence avoid the memory=0A=
> +reclaim recursion deadlocks in the same manner the kernel avoids them.=
=0A=
> +If \fIarg2\fP is 0, the process will clear the IO_FLUSHER state, and the=
=0A=
> +default behavior will be used.=0A=
> +=0A=
> +Examples of IO_FLUSHER applications are FUSE daemons, zoned disk=0A=
> +emulation daemons, etc."=0A=
=0A=
I would replace the "zoned disk emulation daemons" part with the more=0A=
general "SCSI device emulation daemons" since for tcmu-runner at least,=0A=
most emulation handlers can potentially trigger the reclaim deadlock (e.g.=
=0A=
file_handler).=0A=
=0A=
Apart from that, this looks good to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal-Sjgp3cTcYWE@public.gmane.org>=0A=
=0A=
> +.TP=0A=
> +.B PR_GET_IO_FLUSHER (Since Linux 5.6)=0A=
> +Return as the function result 1 if the caller is in the IO_FLUSHER state=
 and=0A=
> +0 if not.=0A=
>  .SH RETURN VALUE=0A=
>  On success,=0A=
>  .BR PR_GET_DUMPABLE ,=0A=
> @@ -1395,6 +1419,7 @@ On success,=0A=
>  .BR PR_GET_SPECULATION_CTRL ,=0A=
>  .BR PR_MCE_KILL_GET ,=0A=
>  .BR PR_CAP_AMBIENT + PR_CAP_AMBIENT_IS_SET ,=0A=
> +.BR PR_GET_IO_FLUSHER ,=0A=
>  and (if it returns)=0A=
>  .BR PR_GET_SECCOMP=0A=
>  return the nonnegative values described above.=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
