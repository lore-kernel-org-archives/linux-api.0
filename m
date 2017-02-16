From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v3 1/4] seccomp: Add sysctl to display available actions
Date: Wed, 15 Feb 2017 19:14:50 -0800
Message-ID: <CALCETrUOvX3krKsrhZmU3QSq1JLX4F3TTV2B8_ybGjd4Yw2HAA@mail.gmail.com>
References: <1487043928-5982-1-git-send-email-tyhicks@canonical.com> <1487043928-5982-2-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487043928-5982-2-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, linux-audit@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, John Crispin <john@phrozen.org>, linux-api@ver.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Feb 13, 2017 at 7:45 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> This patch creates a read-only sysctl containing an ordered list of
> seccomp actions that the kernel supports. The ordering, from left to
> right, is the lowest action value (kill) to the highest action value
> (allow). Currently, a read of the sysctl file would return "kill trap
> errno trace allow". The contents of this sysctl file can be useful for
> userspace code as well as the system administrator.

Would this make more sense as a new seccomp(2) mode a la
SECCOMP_HAS_ACTION?  Then sandboxy things that have no fs access could
use it.

--Andy
