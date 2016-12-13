From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 13:47:03 -0500
Message-ID: <20161213184703.GB17672@htj.duckdns.org>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
 <221e80bd-3d99-6c35-dcd3-b2547f0abb11@schaufler-ca.com>
 <CALAqxLWaJT=a1Cc2Ja8ZuazjJYi3a2WW9ATB0NFP8670Dyq6bg@mail.gmail.com>
 <f7ccb39f-bad8-4a78-c796-90927b839494@schaufler-ca.com>
 <CALAqxLUgmeNxt5B5k720YRM=pUh=a-b2cg+mCM1n1QG-un2ofQ@mail.gmail.com>
 <4c60e1be-c00a-5f26-f5de-7d32b9cb0f62@schaufler-ca.com>
 <CALAqxLUbrO+vzrwgK8_yZS-uru7redOdJCAe2=yA34gwPGC2CQ@mail.gmail.com>
 <b23a2c1f-d720-e299-caea-45a642ee0981@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b23a2c1f-d720-e299-caea-45a642ee0981@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: John Stultz <john.stultz@linaro.org>, Michael Kerrisk <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello, Casey.

On Tue, Dec 13, 2016 at 10:32:14AM -0800, Casey Schaufler wrote:
> > The trouble is that CAP_SYS_NICE or _RESOURCE (which was tried in an
> > earlier version of this patch) aren't necessarily appropriate for
> > non-android systems. See Andy's objection here:
> > https://lkml.org/lkml/2016/11/8/946
> 
> Then we need to see what those as-yet-unimplemented systems
> require and how to address them. I don't think that taking
> the "someone might want it" approach is really appropriate.

I understands that there can be reservations regarding adding a new
CAP but this isn't about someone possibly wanting it in the future.
It's more about overloading existing CAPs leading to permitting
unintended operations.  e.g. ppl who've been delegating
CAP_SYS_RESOURCES would automatically end up delegating cgroup
organization without intending so.  Using an existing cap would have
been nice but it just doesn't look like we have a good one to
overload.

Thanks.

-- 
tejun
