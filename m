From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v2 0/2] Add further ioctl() operations for namespace discovery
Date: Wed, 25 Jan 2017 11:41:42 +1300
Message-ID: <87a8aggjx5.fsf@xmission.com>
References: <93e5c7f9-9dc1-6c93-ad20-0ba053d8bfef@gmail.com>
        <CAKgNAkimuGpJ1MzLs3wexU+tJakX07Kj_1c+bnGjgk3zgDUGLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKgNAkimuGpJ1MzLs3wexU+tJakX07Kj_1c+bnGjgk3zgDUGLg@mail.gmail.com>
        (Michael Kerrisk's message of "Wed, 25 Jan 2017 10:34:18 +1300")
Sender: linux-kernel-owner@vger.kernel.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Linux API <linux-api@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, "W. Trevor King" <wking@tremily.us>, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-api@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
> Do you have any input for this small patch set? I've still to tweak a
> comment as suggested by Trevor King, but otherwise I'd like to know if
> this is good to go for the next merge window.

Apologies I have been bogged down with other things.  Basically the
code looks fine, and now that I have caught up with things I will be
happy to merge your for the next merge window.

I do wonder if returning -EOVERFLOW may be more useful than running
the overflow_uid when mapping fails.

Also, now that I think about it.  Please let's use (uid_t __user *) for
the type of argp.  I think that will be more maintainable in the long
run.  Easier to grep for etc.

Neither of these things are big or would prevent me from merging your
change just things that I think would be nice to have.

Eric
