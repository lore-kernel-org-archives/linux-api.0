From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v4 4/4] seccomp: Add tests for SECCOMP_RET_LOG
Date: Wed, 15 Feb 2017 17:13:38 -0800
Message-ID: <CAGXu5jJYaQTB6g-wgg5TXijVm-LYs6zoUK_GsNh5+ZAF3xMtSA@mail.gmail.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com> <1487044559-6351-5-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487044559-6351-5-git-send-email-tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Crispin <john-Pj+rj9U5foFAfugRpC6u6w@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 7:55 PM, Tyler Hicks <tyhicks-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> Extend the kernel selftests for seccomp to test the newly added
> SECCOMP_RET_LOG action. The added tests follow the example of existing
> tests.
>
> Unfortunately, the tests are not capable of inspecting the audit log to
> verify that the syscall was logged.

It could try to read dmesg... :P But I don't need that for this patch,
though maybe add it to the test's TODO list?

-Kees

-- 
Kees Cook
Pixel Security
