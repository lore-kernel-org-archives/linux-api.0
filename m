From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH v6 10/11] x86/vsyscall/64: Add ENDBR64 to vsyscall
 entry points
Date: Mon, 19 Nov 2018 14:22:50 -0800
Message-ID: <CALCETrWP20o62m_5mp_yCBFNMQ4YYV-kPKiytHObhvJs_bjFVQ@mail.gmail.com>
References: <20181119214934.6174-1-yu-cheng.yu@intel.com> <20181119214934.6174-11-yu-cheng.yu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181119214934.6174-11-yu-cheng.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Yu-cheng Yu <yu-cheng.yu@intel.com>
Cc: X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Balbir Singh <bsingharora@gmail.com>, Cyrill Gorcunov <gorcunov@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Eugene Syromiatnikov <esyr@redhat.com>, Florian Weimer <fweimer@redhat.com>, "H. J. Lu" <hjl.tools@gmail.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Mike Kravetz <mike.kravetz@oracle.com>, Nadav Amit <nadav.am>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 19, 2018 at 1:55 PM Yu-cheng Yu <yu-cheng.yu@intel.com> wrote:
>
> From: "H.J. Lu" <hjl.tools@gmail.com>
>
> Add ENDBR64 to vsyscall entry points.
>
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>

Acked-by: Andy Lutomirski <luto@kernel.org>

although the scenarios where this matters will be extremely rare,
given that this code is mapped NX :)  Tools like 'pin' may care.

--Andy
