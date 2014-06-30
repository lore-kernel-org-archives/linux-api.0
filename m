From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Mon, 30 Jun 2014 14:11:49 -0700
Message-ID: <CALCETrUXgkiNf+pCKL5dyAFRbm4dF4R-E=qf6CzpV5pnsdrBkQ@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <87mwcuw2pj.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <87mwcuw2pj.fsf@tassilo.jf.intel.com>
Sender: linux-security-module-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: David Drysdale <drysdale@google.com>, LSM List <linux-security-module@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 1:40 PM, Andi Kleen <andi@firstfloor.org> wrote:
> David Drysdale <drysdale@google.com> writes:
>
>> Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> provided path, rejecting (with -EACCES) paths that are not beneath
>> the provided dfd.  In particular, reject:
>>  - paths that contain .. components
>>  - paths that begin with /
>>  - symlinks that have paths as above.
>
> How about bind mounts?

What's the problematic scenario?

--Andy
