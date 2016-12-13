From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v5] cgroup: Add new capability to allow a process to
 migrate other tasks between cgroups
Date: Tue, 13 Dec 2016 08:08:16 -0800
Message-ID: <CALAqxLVz4WH5T7mjD1U5XG1pWQCJqsO2LWYcpJ+xDPjRb9QMig@mail.gmail.com>
References: <1481593143-18756-1-git-send-email-john.stultz@linaro.org> <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkhGSYmtqLnCyXH8-dbmBJreo9mbVGRMyd_9hZ5D1F7q4g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry Shmidt <dimitrysh@google.com>, Todd Kjos <tkjos@google.com>, Christian Poetzsch <christian.potzsch@imgtec.com>, Amit Pundir <amit.pundir@linaro.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Kees Cook <keescook@chromium.org>, "Serge E . Hallyn" <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 13, 2016 at 1:47 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On 13 December 2016 at 02:39, John Stultz <john.stultz@linaro.org> wrote:
> So, back to the discussion of silos. I understand the argument for
> wanting a new silo. But, in that case can we at least try not to make
> it a single-use silo?
>
> How about CAP_CGROUP_CONTROL or some such, with the idea that this
> might be a capability that allows the holder to step outside usual
> cgroup rules? At the moment, that capability would allow only one such
> step, but maybe there would be others in the future.

This sounds reasonable to me. Tejun/Andy: Objections?

thanks
-john
