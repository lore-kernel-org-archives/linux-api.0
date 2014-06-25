From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v8 1/1] man-pages: seccomp.2: document syscall
Date: Wed, 25 Jun 2014 14:04:40 +0100
Message-ID: <20140625140440.6870eac1@alan.etchedpixels.co.uk>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
        <20140624205615.GW5412@outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <20140624205615.GW5412@outflux.net>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: Kees Cook <keescook@chromium.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Alexei Starovoitov <ast@plumgrid.com>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org, linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 24 Jun 2014 13:56:15 -0700
Kees Cook <keescook@chromium.org> wrote:

> Combines documentation from prctl, in-kernel seccomp_filter.txt and
> dropper.c, along with details specific to the new syscall.

What is the license on the example ? Probably you want to propogate the
minimal form of the text in seccomp/dropper into the document example to
avoid confusion ?

Alan
