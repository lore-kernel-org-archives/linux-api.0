From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v2 0/7] Rework random blocking
Date: Fri, 20 Sep 2019 07:46:19 -0700
Message-ID: <CALCETrWeWQeotMXbY2yKOmWbhW7HZLYdFBUVcFy3vCmSnm+9Sw@mail.gmail.com>
References: <cover.1568990048.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1568990048.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Theodore Tso <tytso@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, "Ahmed S. Darwish" <darwish.07@gmail.com>, Lennart Poettering <mzxreary@0pointer.de>, "Eric W. Biederman" <ebiederm@xmission.com>, "Alexander E. Patrakov" <patrakov@gmail.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-man <linux-man@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Fri, Sep 20, 2019 at 7:36 AM Andy Lutomirski <luto@kernel.org> wrote:
>
> This makes two major semantic changes to Linux's random APIs:

Hmm.  I have at least two issues in here that need fixing:

 - getrandom() can warn.  Whoops.

 - Repeatedly calling getentropy in GRND_INSECURE mode will interfere
will CRNG init.

v3 will fix these issues.
