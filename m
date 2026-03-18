Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B3736493A;
	Wed, 18 Mar 2026 06:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773815060; cv=none; b=EogV22PWhGsGIAEjhgbe/+qEXbt9Q+Yx/4xDYtZDpWhEaTE2fF+OZ8wLDFk/4nrfcLn7MoghOzOKCq12b+coZYEc0uIZuhTDDFIu4UnXmGAb/8G54wIMIJU7Wjq4GARJjf7GhWpxH8F86T9qwBlojrcYIbD8WrQAyzbYGFTosqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773815060; c=relaxed/simple;
	bh=pAl3NCDU41bTQKWjQ1fx4v1ez6c5MZxvJDobpWAZWPI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IcFajiegPqMGYuvfzNeMvJDsTuKk7xG0zKJUGxiFKCCHAOFPMKmHE17TfftxRFB/JUUg6GLOHE+5SyniyP0PNdF0Ew8mpdUjNmyK7UlteEyIOy+G1MezqLmVqQuVGtjSUiQHpZ+FQuAQjIK0vNIcK0lWhBoAasTDjtsE7aXutxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0T+Bes8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0T+Bes8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81047C19421;
	Wed, 18 Mar 2026 06:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773815059;
	bh=pAl3NCDU41bTQKWjQ1fx4v1ez6c5MZxvJDobpWAZWPI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f0T+Bes8xiS9A0l45/c+XTCgLFlaLmSNEwXKeV0UhdIKVqg8XHB5fceBVlEv1L3h5
	 ogM6c3g4wlNPBR+yvkgm8A8pKuNDRxfsS2DyHMjjVq5LlSKC0I/5/HCqbK3bidn1T2
	 9kN4AAzceTso+wOIn0s85hNexDCCoBN0KlvIen9wZQ1+51wtohABua4OOn6LHwT2Xc
	 aPKny+zxfBx0fH6wjrs11SE5x5RQFA+ASX+tQdHP/741NgtTU70qGvXGqH0ZFzkmsu
	 YPRTJksgl+A8mQGhr3aoEl9BA3Om+TOl0Lt4ezhL6yE745IFf2VAzrWGAQEU6iFTqp
	 TArGYEojn3Fjg==
Date: Wed, 18 Mar 2026 07:24:10 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, linux-api@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org,
 linux-kselftest@vger.kernel.org, workflows@vger.kernel.org,
 tools@kernel.org, x86@kernel.org, Thomas Gleixner <tglx@kernel.org>, "Paul
 E. McKenney" <paulmck@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Dmitry
 Vyukov <dvyukov@google.com>, Randy Dunlap <rdunlap@infradead.org>, Cyril
 Hrubis <chrubis@suse.cz>, Kees Cook <kees@kernel.org>, Jake Edge
 <jake@lwn.net>, David Laight <david.laight.linux@gmail.com>, Askar Safin
 <safinaskar@zohomail.com>, Gabriele Paoloni <gpaoloni@redhat.com>, Mauro
 Carvalho Chehab <mchehab@kernel.org>, Christian Brauner
 <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew
 Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>,
 Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/9] Kernel API Specification Framework
Message-ID: <20260318072410.72618011@foz.lan>
In-Reply-To: <abZTg9ZwnE5J4qXa@laps>
References: <20260313150928.2637368-1-sashal@kernel.org>
	<20260314111822.63a2ba4a@kernel.org>
	<abZTg9ZwnE5J4qXa@laps>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-api@vger.kernel.org
List-Id: <linux-api.vger.kernel.org>
List-Subscribe: <mailto:linux-api+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-api+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 15 Mar 2026 02:36:51 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Sat, Mar 14, 2026 at 11:18:22AM -0700, Jakub Kicinski wrote:
> >On Fri, 13 Mar 2026 11:09:10 -0400 Sasha Levin wrote:  
> >> This enables static analysis tools to verify userspace API usage at compile
> >> time, test generation based on formal specifications, consistent error handling
> >> validation, automated documentation generation, and formal verification of
> >> kernel interfaces.  
> >
> >Could you give some examples? We have machine readable descriptions for
> >Netlink interfaces, we approached syzbot folks and they did not really
> >seem to care for those.  
> 
> Once the API is in a machine-readable format, we can write formatters to
> output whatever downstream tools need. 

Kernel-doc already does that. The way it works is that it handles 
kernel-doc markups on two steps:

- first step: parse kernel-doc markups, function prototypes and data
  types for variables, typedefs, structs, unions, enums.

  This is done inside tools/lib/python/kdoc/kdoc_parser.py.

  The documentation is stored in memory as a list of documentation
  entries. Each element there belongs to class KdocItem.

  It is trivial to output its content in JSON or YAML format. I
  submitted a path series a while ago doing exactly that, aiming to help
  writing unittests for first step:

	https://lore.kernel.org/linux-doc/7648cb5f5a1b501d9ae9a57b4d8dbeb7273d9097.1770128540.git.mchehab+huawei@kernel.org/

  I'm planing to rebase such patch series on the top of my latest
  kernel-doc patch series.

- second step: output generation. There is an abstract class named
  OutputFormat which contains the following output methods:

    def out_doc(self, fname, name, args):
        """Outputs a DOC block."""

    def out_function(self, fname, name, args):
        """Outputs a function."""

    def out_enum(self, fname, name, args):
        """Outputs an enum."""

    def out_var(self, fname, name, args):
        """Outputs a variable."""

    def out_typedef(self, fname, name, args):
        """Outputs a typedef."""

    def out_struct(self, fname, name, args):
        """Outputs a struct."""

  Producing a different output is as easy as doing:

	class MyFormat(OutputFormat):
	...
	    def out_var(self, fname, name, args):
        	self.data =+ f"whatever {name}"
	...


Thanks,
Mauro
