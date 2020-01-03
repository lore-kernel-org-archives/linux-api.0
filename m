From: Alexey Gladkov <gladkov.alexey@gmail.com>
Subject: Re: [PATCH v6 07/10] proc: flush task dcache entries from all procfs
 instances
Date: Fri, 3 Jan 2020 09:56:34 +0100
Message-ID: <20200103085634.6xkgb4aonivjhfnq@comp-core-i7-2640m-0182e6>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
 <20191225125151.1950142-8-gladkov.alexey@gmail.com>
 <8d85ba43-0759-358e-137d-246107bac747@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8d85ba43-0759-358e-137d-246107bac747@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: J Freyensee <why2jjj.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Security Module <linux-security-module@vger.kernel.org>, Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>
List-Id: linux-api@vger.kernel.org

On Mon, Dec 30, 2019 at 02:03:29PM -0800, J Freyensee wrote:
> > +#ifdef CONFIG_PROC_FS
> > +static inline void pidns_proc_lock(struct pid_namespace *pid_ns)
> > +{
> > +	down_write(&pid_ns->rw_proc_mounts);
> > +}
> > +
> > +static inline void pidns_proc_unlock(struct pid_namespace *pid_ns)
> > +{
> > +	up_write(&pid_ns->rw_proc_mounts);
> > +}
> > +
> > +static inline void pidns_proc_lock_shared(struct pid_namespace *pid_ns)
> > +{
> > +	down_read(&pid_ns->rw_proc_mounts);
> > +}
> > +
> > +static inline void pidns_proc_unlock_shared(struct pid_namespace *pid_ns)
> > +{
> > +	up_read(&pid_ns->rw_proc_mounts);
> > +}
> > +#else /* !CONFIG_PROC_FS */
> > +
> Apologies for my newbie question. I couldn't help but notice all these
> function calls are assuming that the parameter struct pid_namespace *pid_ns
> will never be NULL.  Is that a good assumption?

These inline helpers are introduced to improve readability. They only make
sense inside procfs. I don't think that defensive programming is useful
here.

-- 
Rgrds, legion
