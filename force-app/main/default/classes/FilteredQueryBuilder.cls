public without sharing class FilteredQueryBuilder {
    private Map<String, String> params;
    private String sortType;
    private String sortField;
    private String fields;
    private String sObjectType;
    private String limitValue;
    private String offset;
    private String whereField;

    public FilteredQueryBuilder setParams(Map<String, String> params) {
        this.params = params;
        return this;
    }

    public FilteredQueryBuilder setFields(String fields) {
        this.fields = fields;
        return this;
    }

    public FilteredQueryBuilder setSortType(String sortType) {
        this.sortType = sortType;
        return this;
    }

    public FilteredQueryBuilder setSortField(String sortField) {
        this.sortField = sortField;
        return this;
    }

    public FilteredQueryBuilder setWhereField(String whereField) {
        this.whereField = whereField;
        return this;
    }

    public FilteredQueryBuilder setSObjectType(String sObjectType) {
        this.sObjectType = sObjectType;
        return this;
    }

    public FilteredQueryBuilder setLimit(String limitValue) {
        this.limitValue = limitValue;
        return this;
    }

    public FilteredQueryBuilder setOffset(String offset) {
        this.offset = offset;
        return this;
    }

    public String buildSOQL() {
        String query = 'SELECT {0} FROM {1} {2} {3} {4}';
        List<String> queryParams = new List<String> {this.fields, this.sObjectType, this.whereField != null ? 'WHERE ' + this.whereField : '', this.sortField != null ? 'ORDER BY ' + this.sortField : '', this.sortType != null ? this.sortType : ''};

        return String.format(query, queryParams);
    }

    public String buildSOSL() {
        String query = 'FIND {0} IN ALL FIELDS RETURNING {1} ({2})';
        List<String> queryParams = new List<String> {'\'' + this.params.get('searchValue') + '*\'', this.sObjectType, this.fields};

        return String.format(query, queryParams);
    }
}
