From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] pidns: introduce syscall getvpid
Date: Tue, 15 Sep 2015 16:20:52 +0200
Message-ID: <20150915142052.GA14820@redhat.com>
References: <20150915120924.14818.49490.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150915120924.14818.49490.stgit@buzz>
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
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 09/15, Konstantin Khlebnikov wrote:
>
> +SYSCALL_DEFINE3(getvpid, pid_t, pid, pid_t, source, pid_t, target)
> +{
> +#ifdef CONFIG_PID_NS
> +	struct pid_namespace *current_ns = task_active_pid_ns(current);
> +	struct pid_namespace *source_ns = current_ns, *target_ns = current_ns;
> +	struct pid *task_pid;
> +	pid_t result = -ESRCH;
> +
> +	rcu_read_lock();
> +	if (source)
> +		source_ns = ns_of_pid(find_pid_ns(source, current_ns));
> +	if (target)
> +		target_ns = ns_of_pid(find_pid_ns(target, current_ns));
> +	if (source_ns && target_ns) {
> +		task_pid = find_pid_ns(pid, source_ns);
> +		if (task_pid)
> +			result = pid_nr_ns(task_pid, target_ns);
> +	}
> +	rcu_read_unlock();
> +
> +	return result;
> +#else
> +	return pid;
> +#endif /* CONFIG_PID_NS */
> +}

Not sure we actually want ifdef(CONFIG_PID_NS). If this is just optimization
I'd suggest to simply add

	if (!IS_ENABLED(CONFIG_PID_NS))
		return pid;

at the start.

But. Either way this unconditional "return pid" doesn't look right imho.
I think we should return -ESRCH if this pid number is not valid to ensure
we have the same semantics with-or-without CONFIG_PID_NS. So it seems that
you should remove this ifdef, this will also ensure that we return -ESRCH
if (say) source != 0 and find_pid_ns(source) fails.

Oleg.
