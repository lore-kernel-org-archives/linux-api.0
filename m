From: Thomas Garnier <thgarnie@google.com>
Subject: Re: [PATCH v4 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 23 Mar 2017 08:14:44 -0700
Message-ID: <CAJcbSZEqeKVKbtUABzuhavxoH9KWCaVUBG3j5owAwyRhiw8Z7g@mail.gmail.com>
References: <20170322203834.67556-1-thgarnie@google.com> <CALCETrV6K8iSfAwojMFyLrbb3CG2aF4k5hPWc7EDV4ErPDq64w@mail.gmail.com>
 <CAJcbSZGLAXmE_mFZMAZgioWExzm3A4vXBKLGJ7DZNAbJOcH8Zw@mail.gmail.com> <f0cf8766-4ee9-5386-5454-2301f429464c@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f0cf8766-4ee9-5386-5454-2301f429464c@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, =?UTF-8?Q?Ren=C3=A9_Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>
List-Id: linux-api@vger.kernel.org

Okay well then people are fine with a BUG_ON approach. I will do a
next iteration tailored to that. I will also try to add the static
inline suggestion from Peter.

On Wed, Mar 22, 2017 at 1:54 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 03/22/17 13:49, Thomas Garnier wrote:
>>
>> We can default to BUGging. I think my approach was avoiding doing a
>> BUG_ON just to avoid breaking people.
>>
>
> Breaking on a potentially-exploitable bug is a feature.
>
>         -hpa
>
>



-- 
Thomas
