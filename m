From: Daniel Colascione <dancol@google.com>
Subject: Re: [PATCH 1/1] userfaultfd: require CAP_SYS_PTRACE for UFFD_FEATURE_EVENT_FORK
Date: Tue, 5 Nov 2019 07:55:17 -0800
Message-ID: <CAKOZuev93zDGNPX+ySg_jeUg4Z3zKMcpABekUQvHA01kTVn4=A@mail.gmail.com>
References: <1572967777-8812-1-git-send-email-rppt@linux.ibm.com> <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1572967777-8812-2-git-send-email-rppt@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Rapoport <rppt@linux.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Lokesh Gidra <lokeshgidra@google.com>, Nick Kralevich <nnk@google.com>, Nosh Minwalla <nosh@google.com>, Pavel Emelyanov <ovzxemul@gmail.com>, Tim Murray <timmurray@google.com>, Linux API <linux-api@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 5, 2019 at 7:29 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Current implementation of UFFD_FEATURE_EVENT_FORK modifies the file
> descriptor table from the read() implementation of uffd, which may have
> security implications for unprivileged use of the userfaultfd.
>
> Limit availability of UFFD_FEATURE_EVENT_FORK only for callers that have
> CAP_SYS_PTRACE.

Thanks. But shouldn't we be doing the capability check at
userfaultfd(2) time (when we do the other permission checks), not
later, in the API ioctl?
