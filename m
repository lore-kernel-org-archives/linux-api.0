From: Jann Horn <jannh@google.com>
Subject: Re: [RESEND RFC PATCH 0/1] CAP_SYS_NICE inside user namespace
Date: Mon, 18 Nov 2019 20:36:22 +0100
Message-ID: <CAG48ez3HfUx2aRvqR_bWnGoTshrHnUzxUNt7K6Sv7cqtPDWaWw@mail.gmail.com>
References: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1574096478-11520-1-git-send-email-prakash.sangappa@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 18, 2019 at 6:04 PM Prakash Sangappa
<prakash.sangappa@oracle.com> wrote:
> Some of the capabilities(7) which affect system wide resources, are ineffective
> inside user namespaces. This restriction applies even to root user( uid 0)
> from init namespace mapped into the user namespace. One such capability
> is CAP_SYS_NICE which is required to change process priority. As a result of
> which the root user cannot perform operations like increase a process priority
> using -ve nice value or set RT priority on processes inside the user namespace.
> A workaround to deal with this restriction is to use the help of a process /
> daemon running outside the user namespace to change process priority, which is
> a an inconvenience.

What is the goal here, in the big picture? Is your goal to allow
container admins to control the priorities of their tasks *relative to
each other*, or do you actually explicitly want container A to be able
to decide that its current workload is more timing-sensitive than
container B's?
