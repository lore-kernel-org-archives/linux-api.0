From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC v11][PATCH 03/13] General infrastructure for checkpoint
 restart
Date: Fri, 05 Dec 2008 23:26:06 -0800
Message-ID: <1228548366.13046.614.camel@localhost>
References: <1228498282-11804-1-git-send-email-orenl@cs.columbia.edu>
	 <1228498282-11804-4-git-send-email-orenl@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1228498282-11804-4-git-send-email-orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Torvalds <torvalds-3NddpPZAyC0@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Serge Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, MinChan Kim <minchan.kim-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 2008-12-05 at 12:31 -0500, Oren Laadan wrote:
> diff --git a/include/linux/checkpoint.h b/include/linux/checkpoint.h
> new file mode 100644
> index 0000000..63f298f
> --- /dev/null
> +++ b/include/linux/checkpoint.h
[]
> +#define cr_debug(fmt, args...)  \
> +	pr_debug("[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__, ## args)
> +

perhaps:

#define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__

and use pr_debug instead?


--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
