From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 13:53:35 -0500
Message-ID: <20161213185335.GD17672@htj.duckdns.org>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org>
 <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
 <CALAqxLVz4WH5T7mjD1U5XG1pWQCJqsO2LWYcpJ+xDPjRb9QMig@mail.gmail.com>
 <20161213184057.GA17672@htj.duckdns.org>
 <CALAqxLU=3CC3o6Z_-bzuvtOd6=GAZBfmgbEk9P1UP==PGyJ3bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALAqxLU=3CC3o6Z_-bzuvtOd6=GAZBfmgbEk9P1UP==PGyJ3bg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 13, 2016 at 10:47:19AM -0800, John Stultz wrote:
> > Control group control?  The word control has a specific meaning for
> > cgroups and that second control doesn't make much sense to me.
> 
> But this would go against the long tradition of RAS syndrome and
> things like "struct task_struct".  :)

Well, now that you put it that way, it's starting to look good. :)
But, let's just go for CAP_CGROUP if everyone is okay with it.

Thanks.

-- 
tejun
