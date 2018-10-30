From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 1/2] seccomp: add a return code to trap to userspace
Date: Tue, 30 Oct 2018 17:39:26 +0100
Message-ID: <20181030163926.GC7643@redhat.com>
References: <20181029224031.29809-1-tycho@tycho.ws>
 <20181029224031.29809-2-tycho@tycho.ws>
 <20181030150254.GB3385@redhat.com>
 <20181030155403.GC7343@cisco>
 <20181030162752.GB7643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181030162752.GB7643@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tycho Andersen <tycho@tycho.ws>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "Eric W . Biederman" <ebiederm@xmission.com>, "Serge E . Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Aleksa Sarai <asarai@suse.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 10/30, Oleg Nesterov wrote:
>
> On 10/30, Tycho Andersen wrote:
> >
> > @@ -828,6 +823,11 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
> >  	 */
> >  	rmb();
> >
> > +	if (!sd) {
> > +		populate_seccomp_data(&sd_local);
> > +		sd = &sd_local;
> > +	}
> > +
>
> To me it would be more clean to remove the "if (!sd)" check, case(SECCOMP_RET_TRACE)
> in __seccomp_filter() can simply do populate_seccomp_data(&sd_local) unconditionally
> and pass &sd_local to __seccomp_filter().

Ah, please ignore, emulate_vsyscall() does secure_computing(NULL).

Btw. why __seccomp_filter() doesn't return a boolean?

Or at least, why can't case(SECCOMP_RET_TRACE) simply do

	return __seccomp_filter(this_syscall, NULL, true);

?

Oleg.
