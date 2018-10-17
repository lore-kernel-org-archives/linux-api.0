From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/2] sysctl: handle overflow in proc_get_long
Date: Tue, 16 Oct 2018 19:19:35 -0700
Message-ID: <CAGXu5jJTaOyzPUYMCi9_vbxCUhLz09C-LEQL9dmM+pt_xfxcQw@mail.gmail.com>
References: <20181016223322.16844-1-christian@brauner.io> <20181016223322.16844-2-christian@brauner.io>
 <877eihjw0n.fsf@xmission.com> <CAHrFyr6AeZzfGkQneiyoLz6YZ-vnyyQWTtc0HK-tqVJkoXt=4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHrFyr6AeZzfGkQneiyoLz6YZ-vnyyQWTtc0HK-tqVJkoXt=4w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christian Brauner <christian@brauner.io>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Lawrence <joe.lawrence@redhat.com>, Waiman Long <longman@redhat.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Oct 16, 2018 at 5:24 PM, Christian Brauner <christian@brauner.io> wrote:
> Right, but if you write a value that exceeds the buffer of 22 chars that is used
> to parse you already get EINVAL back on current kernels.
> So it didn't feel like returning EOVERFLOW or ERANGE might make sense.
> I saw a change in 4.10 or 4.11 as well that used EINVAL on UINT_MAX overflow
> or something. EINVAL might be enough information for userspace here ?/.

I'd agree: I think there is more precedent for EINVAL.

-Kees

-- 
Kees Cook
Pixel Security
