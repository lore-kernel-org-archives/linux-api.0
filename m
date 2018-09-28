From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v7 0/6] seccomp trap to userspace
Date: Fri, 28 Sep 2018 15:34:31 -0700
Message-ID: <CAGXu5j+GTwOZnNscfMmArxxJgNvPETgBns1Y6u11tapkoOwn+w@mail.gmail.com>
References: <20180927151119.9989-1-tycho@tycho.ws> <686fe047-16e6-3dfc-6284-ed574d97ad2f@gmail.com>
 <20180928220359.GF18045@cisco.lan> <CAKgNAkgcHENKrT=n4_YbmxJCOaY2Z+SXJcfuw9j7uOJwgym3Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkgcHENKrT=n4_YbmxJCOaY2Z+SXJcfuw9j7uOJwgym3Dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Tycho Andersen <tycho@tycho.ws>, lkml <linux-kernel@vger.kernel.org>, Containers <containers@lists.linux-foundation.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@ubuntu.com>, Tyler Hicks <tyhicks@canonical.com>, Akihiro Suda <suda.akihiro@lab.ntt.co.jp>, Jann Horn <jannh@google.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 28, 2018 at 3:16 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Tycho,
>
> On Sat, 29 Sep 2018 at 00:04, Tycho Andersen <tycho@tycho.ws> wrote:
>>
>> On Fri, Sep 28, 2018 at 11:57:40PM +0200, Michael Kerrisk (man-opages) wrote:
>> > Hi Tycho,
>> >
>> > On 09/27/2018 05:11 PM, Tycho Andersen wrote:
>> > > Hi all,
>> > >
>> > > Here's v7 of the seccomp trap to userspace set. There are various minor
>> > > changes and bug fixes, but two major changes:
>> > >
>> > > * We now pass fds to the tracee via an ioctl, and do it immediately when
>> > >    the ioctl is called. For this we needed some help from the vfs, so
>> > >    I've put the one patch in this series and cc'd fsdevel. This does have
>> > >    the advantage that the feature is now totally decoupled from the rest
>> > >    of the set, which is itself useful (thanks Andy!)
>> > >
>> > > * Instead of putting all of the notification related stuff into the
>> > >    struct seccomp_filter, it now lives in its own struct notification,
>> > >    which is pointed to by struct seccomp_filter. This will save a lot of
>> > >    memory (thanks Tyler!)
>> >
>> > Is there a documentation (man page) patch for this API change?
>>
>> Not yet, but once we decide on a final API I'll prepare one.
>
> Honestly, the production of such documentation should be part of the
> evolution towards the final API...
>
> Documentation is not an afterthought. It's a tool for pushing you, the
> developer (and others, your reviewers) to more deeply consider your
> design.

In Tycho's defense, he did write up documentation in Documentation/
for the feature, so it won't be an afterthought. :) But yes, there's
no manpage delta yet.

-Kees

-- 
Kees Cook
Pixel Security
