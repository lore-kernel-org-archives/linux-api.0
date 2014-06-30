From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Mon, 30 Jun 2014 08:53:01 -0700
Message-ID: <CALCETrWJ-rqDo8OvSZWPUt1806gObNtwVHvC4M6kfQgvd3Eg9w@mail.gmail.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
 <1404124096-21445-2-git-send-email-drysdale@google.com> <CALCETrU=HLmw9n-DxPkFV1xP5wtzQ7-YF3-uao6YiGZODA9kdw@mail.gmail.com>
 <20140630154928.GB10375@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140630154928.GB10375@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Drysdale <drysdale@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LSM List <linux-security-module@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Linux API <linux-api@vger.kernel.org>, Meredydd Luff <meredydd@senatehouse.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 30, 2014 at 8:49 AM, David Drysdale <drysdale@google.com> wrote:
> On Mon, Jun 30, 2014 at 07:49:41AM -0700, Andy Lutomirski wrote:
>> On Jun 30, 2014 3:36 AM, "David Drysdale" <drysdale@google.com> wrote:
>> >
>> > Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
>> > provided path, rejecting (with -EACCES) paths that are not beneath
>> > the provided dfd.  In particular, reject:
>> >  - paths that contain .. components
>> >  - paths that begin with /
>> >  - symlinks that have paths as above.
>>
>> I like this a lot.  However, I think I'd like it even better if it
>> were AT_BENEATH_ONLY so that it could be added to the rest of the *at
>> family.
>>
>> --Andy
>
> Wouldn't it need to be both O_BENEATH_ONLY (for openat()) and
> AT_BENEATH_ONLY (for other *at() functions), like O_NOFOLLOW and
> AT_SYMLINK_NOFOLLOW?  (I.e. aren't the AT_* flags in a different
> numbering space than O_* flags?)
>
> Or am I misunderstanding?
>

Ugh, you're probably right.  I wish openat had separate flags and
atflags arguments.  Oh well.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
