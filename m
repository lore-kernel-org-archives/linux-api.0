From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 3/9] eeprom: Add a simple EEPROM framework for eeprom
 providers
Date: Tue, 24 Mar 2015 15:53:18 -0700
Message-ID: <20150324225317.GD28997@sirena.org.uk>
References: <1427236116-18531-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1427236208-18667-1-git-send-email-srinivas.kandagatla@linaro.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427236208-18667-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Maxime Ripard <maxime.ripard@free-electrons.com>, Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, arnd@arndb.de, sboyd@codeaurora.org
List-Id: linux-api@vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 24, 2015 at 10:30:08PM +0000, Srinivas Kandagatla wrote:

> +static ssize_t bin_attr_eeprom_write(struct file *filp, struct kobject *kobj,
> +				     struct bin_attribute *attr,
> +				     char *buf, loff_t offset, size_t count)
> +{
> +	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct eeprom_device *eeprom = to_eeprom(dev);
> +	int rc;
> +
> +	if (offset > eeprom->size)
> +		return -EINVAL;
> +
> +	if (offset + count > eeprom->size)
> +		count = eeprom->size - offset;
> +
> +	rc = regmap_bulk_write(eeprom->regmap, offset,
> +			       buf, count/eeprom->stride);

Are you sure that this and the read interface should be using the bulk
interface and not the raw interface - do we want the byte swapping that
the bulk interface provides?

I'm also not entirely able to convince myself that the above error
checks and code line up with what I'd expect the userspace ABI to be, we
seem to be treating offset as both a byte offset into the data (which is
what I'd expect the userspace ABI to do) and a word based index into the
data (which is what the regmap API is doing).  For example with 16 bit
words offset 2 will start at the 5th byte of data but if userspace seeks
to offset 5 it will get the 11th byte and onwards.

The stride and the word size are separate, they will frequently line up
for memory mapped devices but typically won't for other devices.  I
think you need more data mangling to handle this robustly.

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVEerdAAoJECTWi3JdVIfQ0AgH/jQqDMg2Y6nJw4lYfsyixUxj
4tUcJI9R4zsV/r5Aj0L2SbIlQSGwSMNL94NQYC52SZoIhMm/2P0YK6rUfIaQszEF
lXxeeFFvGLtsU83HbriZDgDRPURy05nUOXR85V2T3fZxaXUM07F0GPow7WsivCte
osU4dm4LyOHG3W8qrZS1PIPaGjS5l1DoguDTM8CsW5OSwWtQmklhqxT8GSFDnArb
aFsnqgScSW9O1+6BRIVRCkIkuZ6ygOBK3oBmR3FgZbLi7GxGE8rzRz3n/kMN79a2
e2OtRVoCutgT5bI3vkKOcXptO8HdRMgBfHaQ46crxrpXbPvJ11JhxCgQbB7E+ew=
=+cVU
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
