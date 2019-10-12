From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 6/7] Allow users to require UFFD_SECURE
Date: Sat, 12 Oct 2019 16:12:49 -0700
Message-ID: <CALCETrWF61dmSpMEYvqa2FHWL8Zj6GJtevFTfymV20CCjiqRcg@mail.gmail.com>
References: <20191012191602.45649-1-dancol@google.com> <20191012191602.45649-7-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191012191602.45649-7-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Colascione <dancol@google.com>
Cc: Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, lokeshgidra@google.com, Nick Kralevich <nnk@google.com>, nosh@google.com, Tim Murray <timmurray@google.com>
List-Id: linux-api@vger.kernel.org

On Sat, Oct 12, 2019 at 12:16 PM Daniel Colascione <dancol@google.com> wrote:
>
> This change adds 2 as an allowable value for
> unprivileged_userfaultfd. (Previously, this sysctl could be either 0
> or 1.) When unprivileged_userfaultfd is 2, users with CAP_SYS_PTRACE
> may create userfaultfd with or without UFFD_SECURE, but users without
> CAP_SYS_PTRACE must pass UFFD_SECURE to userfaultfd in order for the
> system call to succeed, effectively forcing them to opt into
> additional security checks.

This patch can go away entirely if you make UFFD_SECURE automatic.
