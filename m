From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/1] ns: introduce proc_get_ns_by_fd()
Date: Fri, 25 Sep 2015 19:56:54 +0200
Message-ID: <20150925175654.GA12504@redhat.com>
References: <20150925135246.27620.97496.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150925135246.27620.97496.stgit@buzz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/25, Konstantin Khlebnikov wrote:
>
> +struct ns_common *proc_ns_fdget(int fd, int nstype, struct fd *fd_ref)
>  {
> -	struct file *file;
> +	struct ns_common *ns;
> +	struct fd f;
>  
> -	file = fget(fd);
> -	if (!file)
> +	f = fdget(fd);
> +	if (!f.file)
>  		return ERR_PTR(-EBADF);
>  
> -	if (file->f_op != &ns_file_operations)
> +	if (f.file->f_op != &ns_file_operations)
> +		goto out_invalid;
> +
> +	ns = get_proc_ns(file_inode(f.file));
> +	if (nstype && (ns->ops->type != nstype))
>  		goto out_invalid;
>  
> -	return file;
> +	*fd_ref = f;
> +	return ns;
>  
>  out_invalid:
> -	fput(file);
> +	fdput(f);
>  	return ERR_PTR(-EINVAL);
>  }

Well yes, fdget() makes sense but this is minor.

Honestly, I do not really like the new helper... I understand this
is subjective, so I won't insist. But how about 1/1? We do not need
fd/file at all. With this patch your sys_getvpid() can just use
proc_get_ns_by_fd(fd, CLONE_NEWPID) and put_pid_ns().

Eric, what do you think?

See also "TODO" in the changelog.

Oleg.
