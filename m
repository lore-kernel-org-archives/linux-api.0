From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] User namespace related fixes for v4.2
Date: Fri, 3 Jul 2015 15:10:40 -0700
Message-ID: <CA+55aFw-DK-xDC-3HYa=BMX8WNyQgT9O01tihrAS9+-7PPj_jA@mail.gmail.com>
References: <87381eyz26.fsf@x220.int.ebiederm.org>
	<CA+55aFysKDXr2HEwNzm3z9QOw=E4ZeWcvYQ-xLhy5_k+rGbeRg@mail.gmail.com>
	<87pp4eqktr.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87pp4eqktr.fsf@x220.int.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Containers <containers@lists.linux-foundation.org>, "<linux-fsdevel@vger.kernel.org>" <linux-fsdevel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "Serge E. Hallyn" <serge@hallyn.com>, Richard Weinberger <richard@nod.at>, Kenton Varda <kenton@sandstorm.io>, Michael Kerrisk-manpages <mtk.manpages@gmail.com>, =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>, Eric Windisch <ewindisch@docker.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>, Omar Sandoval <osandov@osandov.com>, Ivan Delalande <colona@arista.com>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 29, 2015 at 2:13 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Can you live with the patch below and committing to never supporting
> executables on proc and sysfs?

Sure. I don't think executables make any sense what-so-ever in those
filesystems. I think it's fine saying that /proc and /sys cannot have
executables in them, and then use that flag to just ignore the
relevant mount flags.

Al, comments?

                  Linus
