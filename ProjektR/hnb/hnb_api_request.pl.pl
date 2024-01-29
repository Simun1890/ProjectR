use LWP::Simple;
use JSON;
use XML::Simple;
use DateTime;

my $url = 'https://api.hnb.hr/tecajn-eur/v3';
my $response = get($url);

if ($response) {
    my $tecajevi = decode_json($response);

    my $today = DateTime->now->ymd;  # Format datuma: YYYY-MM-DD
    my $xml_data = XMLout({ tecajevi => $tecajevi }, RootName => "tecajn_response_all_currencies_v3_$today");

    open my $file, '>', "tecajn_response_all_currencies_v3_$today.xml" or die "Cannot open file tecajn_response_all_currencies_v3_$today.xml: $!";
    print $file $xml_data;
    close $file;

    print "Podaci su spremljeni u datoteku tecajn_response_all_currencies_v3_$today.xml\n";
} else {
    die "Error fetching the URL: $!\n";
}