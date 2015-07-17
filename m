From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 1/2] capabilities: Ambient capabilities
Date: Fri, 17 Jul 2015 16:10:09 -0700
Message-ID: <CAGXu5j+V0fMae5OOHwU5DcMrG0TCANYOTfbz5+LDZZqYKcXAaw@mail.gmail.com>
References: <cover.1436903028.git.luto@kernel.org>
	<9f660ee708e58892bfa7012b6b9c840298e24544.1436903028.git.luto@kernel.org>
	<alpine.LRH.2.11.1507152033420.8351@namei.org>
	<CALCETrWMBZ0p7P1FvtrYp5ChJXvvRzy0JpjS8KwUUa5m9gqgQA@mail.gmail.com>
	<alpine.DEB.2.11.1507171539590.13763@east.gentwo.org>
	<20150717135057.8e09390f1c10bc11d10a42f5@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150717135057.8e09390f1c10bc11d10a42f5@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Andy Lutomirski <luto@amacapital.net>, James Morris <jmorris@namei.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linuxfoundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, James Morris <james.l.morris@oracle.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Ted Ts'o <tytso@mit.edu>, "Andrew G. Morgan" <morgan@kernel.org>, Linux API <linux-api@vger.kernel.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-security-module <linux-security-module@vger.kernel.org>, Aaron Jones <aaronmdjones@gmail.com>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Markku Savela <msa@moth.iki.fi>, Jonathan Corbet <corbet@lwn.net>
List-Id: linux-api@vger.kernel.org

On Fri, Jul 17, 2015 at 1:50 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 17 Jul 2015 15:40:57 -0500 (CDT) Christoph Lameter <cl@linux.com> wrote:
>
>> Here is a test program that can be used to verify the functionality.
>
> I slurped that into the changelog.
>
> Adding a selftest into tools/testing/selftests/ would be appropriate.

Yes please! I'd love to see a general privilege transition testing
area. But starting with just this would be fine. :)

-Kees


-- 
Kees Cook
Chrome OS Security
