From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] seccomp: Add protection keys into seccomp_data
Date: Mon, 29 Oct 2018 09:37:32 -0700
Message-ID: <7d93080b-68bd-7563-bd3b-e7ee1545e367@intel.com>
References: <20181029112343.27454-1-msammler@mpi-sws.org>
 <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAGXu5jJ2fFmEXfUzga3XBXcsHPuPWWf5zLeyn8+Z1oZVa8oTuQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: Kees Cook <keescook@chromium.org>, Michael Sammler <msammler@mpi-sws.org>
Cc: Will Drewry <wad@chromium.org>, Linux API <linux-api@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Ram Pai <linuxram@us.ibm.com>, Andy Lutomirski <luto@amacapital.net>, PowerPC <linuxppc-dev@lists.ozlabs.org>
List-Id: linux-api@vger.kernel.org

On 10/29/18 9:25 AM, Kees Cook wrote:
> On Mon, Oct 29, 2018 at 4:23 AM, Michael Sammler <msammler@mpi-sws.org> wrote:
>> Add the current value of an architecture specific protection keys
>> register (currently PKRU on x86) to data available for seccomp-bpf
>> programs to work on. This allows filters based on the currently
>> enabled protection keys.

How does the current "assignment" of protection keys to the various uses
get communicated to the filter?

I'm not sure this is a great use for PKRU.  I *think* the basic problem
is that you want to communicate some rights information down into a
filter, and you want to communicate it with PKRU.  While it's handy to
have an extra register that nobody (generally) mucks with, I'm not quite
convinced that we want to repurpose it this way.

Also, I'm not sure the kernel provides the PKRU guarantees you want at
the moment.  Our implementation *probably* works, but it's mostly by
accident.
