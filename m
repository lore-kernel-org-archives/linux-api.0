From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Add /proc/pid_gen
Date: Wed, 21 Nov 2018 14:12:20 -0800
Message-ID: <20181121141220.0e533c1dcb4792480efbf3ff@linux-foundation.org>
References: <20181121201452.77173-1-dancol@google.com>
        <20181121205428.165205-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121205428.165205-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, timmurray@google.com, primiano@google.com, joelaf@google.com, Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, Prashant Dhamdhere <pdhamdhe@redhat.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Steven Rostedt (VMware)" <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Josh Poimboeuf <jpoimboe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, KJ Tsanaktsidis <ktsanaktsidis@zendesk.com>
List-Id: linux-api@vger.kernel.org

On Wed, 21 Nov 2018 12:54:20 -0800 Daniel Colascione <dancol@google.com> wrote:

> Trace analysis code needs a coherent picture of the set of processes
> and threads running on a system. While it's possible to enumerate all
> tasks via /proc, this enumeration is not atomic. If PID numbering
> rolls over during snapshot collection, the resulting snapshot of the
> process and thread state of the system may be incoherent, confusing
> trace analysis tools. The fundamental problem is that if a PID is
> reused during a userspace scan of /proc, it's impossible to tell, in
> post-processing, whether a fact that the userspace /proc scanner
> reports regarding a given PID refers to the old or new task named by
> that PID, as the scan of that PID may or may not have occurred before
> the PID reuse, and there's no way to "stamp" a fact read from the
> kernel with a trace timestamp.
> 
> This change adds a per-pid-namespace 64-bit generation number,
> incremented on PID rollover, and exposes it via a new proc file
> /proc/pid_gen. By examining this file before and after /proc
> enumeration, user code can detect the potential reuse of a PID and
> restart the task enumeration process, repeating until it gets a
> coherent snapshot.
> 
> PID rollover ought to be rare, so in practice, scan repetitions will
> be rare.

In general, tracing is a rather specialized thing.  Why is this very
occasional confusion a sufficiently serious problem to warrant addition
of this code?

Which userspace tools will be using pid_gen?  Are the developers of
those tools signed up to use pid_gen?

> --- a/include/linux/pid.h
> +++ b/include/linux/pid.h
> @@ -112,6 +112,7 @@ extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
>  int next_pidmap(struct pid_namespace *pid_ns, unsigned int last);
>  
>  extern struct pid *alloc_pid(struct pid_namespace *ns);
> +extern u64 read_pid_generation(struct pid_namespace *ns);

pig_generation_read() would be a better (and more idiomatic) name.

>  extern void free_pid(struct pid *pid);
>  extern void disable_pid_allocation(struct pid_namespace *ns);
>
> ...
>
> +u64 read_pid_generation(struct pid_namespace *ns)
> +{
> +	u64 generation;
> +
> +
> +	spin_lock_irq(&pidmap_lock);
> +	generation = ns->generation;
> +	spin_unlock_irq(&pidmap_lock);
> +	return generation;
> +}

What is the spinlocking in here for?  afaict the only purpose it serves
is to make the 64-bit read atomic, so it isn't needed on 32-bit?

>  void disable_pid_allocation(struct pid_namespace *ns)
>  {
>  	spin_lock_irq(&pidmap_lock);
> @@ -449,6 +463,17 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
>  	return idr_get_next(&ns->idr, &nr);
>  }
>  
> +#ifdef CONFIG_PROC_FS
> +static int pid_generation_show(struct seq_file *m, void *v)
> +{
> +	u64 generation =
> +		read_pid_generation(proc_pid_ns(file_inode(m->file)));

	u64 generation;

	generation = read_pid_generation(proc_pid_ns(file_inode(m->file)));

is a nicer way of avoiding column wrap.

> +	seq_printf(m, "%llu\n", generation);
> +	return 0;
> +
> +};
> +#endif
> +
>  void __init pid_idr_init(void)
>  {
>  	/* Verify no one has done anything silly: */
> @@ -465,4 +490,13 @@ void __init pid_idr_init(void)
>  
>  	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
>  			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
> +
> +}
> +
> +void __init pid_proc_init(void)
> +{
> +	/* pid_idr_init is too early, so get a separate init function. */

s/get a/use a/

> +#ifdef CONFIG_PROC_FS
> +	WARN_ON(!proc_create_single("pid_gen", 0, NULL, pid_generation_show));
> +#endif
>  }

This whole function could vanish if !CONFIG_PROC_FS.  Doesn't matter
much with __init code though.
