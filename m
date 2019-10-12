From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 3/7] Add a UFFD_SECURE flag to the userfaultfd API.
Date: Sat, 12 Oct 2019 16:10:16 -0700
Message-ID: <CALCETrVZHd+csdRL-uKbVN3Z7yeNNtxiDy-UsutMi=K3ZgCiYw@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-4-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-4-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, lokeshgidra@google.com, Nick Kralevich <nnk@google.com>, nosh@google.com, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:16 PM Daniel Colascione <dancol@google.com> wrote:
>
> The new secure flag makes userfaultfd use a new "secure" anonymous
> file object instead of the default one, letting security modules
> supervise userfaultfd use.
>
> Requiring that users pass a new flag lets us avoid changing the
> semantics for existing callers.

Is there any good reason not to make this be the default?

The only downside I can see is that it would increase the memory usage
of userfaultfd(), but that doesn't seem like such a big deal.  A
lighter-weight alternative would be to have a single inode shared by
all userfaultfd instances, which would require a somewhat different
internal anon_inode API.

In any event, I don't think that "make me visible to SELinux" should
be a choice that user code makes.

--Andy
